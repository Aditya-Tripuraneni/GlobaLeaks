# -*- coding: utf-8
import json

from datetime import timedelta
from twisted.internet import defer

from globaleaks.rest import errors
from globaleaks.rest.cache import Cache
from globaleaks.state import State
from globaleaks.utils.json import JSONEncoder
from globaleaks.utils.utility import datetime_now


def decorator_rate_limit(f):
    # Decorator that enforces rate limiting on authenticated whistleblowers' sessions
    def wrapper(self, *args, **kwargs):
        if self.session and self.session.user_role == 'whistleblower':
            now = datetime_now()
            if now > self.session.ratelimit_time + timedelta(seconds=30):
                self.session.ratelimit_time = now
                self.session.ratelimit_count = 0

            self.session.ratelimit_count += 1

            period = max(now.timestamp() - self.session.ratelimit_time.timestamp(), 1)

            if (self.session.ratelimit_count / period) > 5:
                raise errors.NotAuthenticated

        return f(self, *args, **kwargs)

    return wrapper



def decorator_require_session_or_token(f):
    # Decorator that ensures a token or a session is included in the request
    def wrapper(self, *args, **kwargs):
        if not self.request.uri.endswith(b"/api/token") and not self.token and not self.session:
            raise errors.InternalServerError("Invalid request: No token and no session")

        return f(self, *args, **kwargs)

    return wrapper


def decorator_authentication(f, roles):
    # Decorator that performs role checks on the user session
    def wrapper(self, *args, **kwargs):
        if (('any' in roles) or
            ((self.session and self.session.tid == self.request.tid) and
             (('user' in roles and
               self.session.user_role in ['admin', 'receiver', 'custodian']) or
              (self.session.user_role in roles)))):

            return f(self, *args, **kwargs)

        raise errors.NotAuthenticated

    return wrapper


def decorator_cache_get(f):
    # Decorator that checks if the requests resource is cached
    def wrapper(self, *args, **kwargs):
        c = Cache.get(self.request.tid, self.request.path, self.request.language)
        if c is None:
            d = defer.maybeDeferred(f, self, *args, **kwargs)

            def callback(data):
                if isinstance(data, (dict, list)):
                    self.request.setHeader(b'content-type', b'application/json')
                    data = json.dumps(data, cls=JSONEncoder)

                c = self.request.responseHeaders.getRawHeaders(b'Content-type', [b'application/json'])[0]
                return Cache.set(self.request.tid, self.request.path, self.request.language, c, data)[1]

            d.addCallback(callback)

            return d

        else:
            self.request.setHeader(b'Content-type', c[0])

        return c[1]

    return wrapper


def decorator_cache_invalidate(f):
    # Decorator that invalidates the requests cache
    def wrapper(self, *args, **kwargs):
        if self.invalidate_cache:
            Cache.invalidate(self.request.tid)

        return f(self, *args, **kwargs)

    return wrapper


def decorate_method(h, method):
    roles = getattr(h, 'check_roles')
    if isinstance(roles, str):
        roles = {roles}

    f = getattr(h, method)

    if State.settings.enable_api_cache:
        if method == 'get':
            if h.cache_resource:
                f = decorator_cache_get(f)
        elif method in ['delete', 'post', 'put']:
            if h.invalidate_cache:
                f = decorator_cache_invalidate(f)

    f = decorator_rate_limit(f)

    if method != 'get':
        f = decorator_require_session_or_token(f)

    f = decorator_authentication(f, roles)

    setattr(h, method, f)
