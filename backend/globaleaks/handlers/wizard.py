# -*- coding: utf-8
#
# Handlers implementing platform wizard
from globaleaks import models
from globaleaks.db import db_refresh_tenant_cache
from globaleaks.handlers.admin.context import db_create_context
from globaleaks.handlers.admin.node import db_update_enabled_languages
from globaleaks.handlers.admin.user import db_create_user
from globaleaks.handlers.base import BaseHandler
from globaleaks.models import config, profiles
from globaleaks.orm import tw
from globaleaks.rest import requests, errors
from globaleaks.utils.crypto import Base64Encoder, GCE
from globaleaks.utils.log import log


def db_wizard(session, tid, hostname, request):
    """
    Transaction for the handling of wizard request

    :param session: An ORM session
    :param tid: A tenant ID
    :param request: A user request
    """
    language = request['node_language']

    root_tenant_node = config.ConfigFactory(session, 1)

    if tid == 1:
        node = root_tenant_node
        encryption = True
        escrow = request['admin_escrow']
    else:
        node = config.ConfigFactory(session, tid)
        encryption = root_tenant_node.get_val('encryption')
        escrow = root_tenant_node.get_val('escrow')

    if node.get_val('wizard_done'):
        log.err("DANGER: Wizard already initialized!", tid=tid)
        raise errors.ForbiddenOperation

    db_update_enabled_languages(session, tid, [language], language)

    node.set_val('encryption', encryption)
    node.set_val('escrow', escrow)

    node.set_val('name', request['node_name'])
    node.set_val('default_language', language)
    node.set_val('wizard_done', True)
    node.set_val('enable_developers_exception_notification', request['enable_developers_exception_notification'])
    node.set_val('hostname', hostname)

    profiles.load_profile(session, tid, request['profile'])

    if encryption:
        if escrow:
            crypto_escrow_prv_key, crypto_escrow_pub_key = GCE.generate_keypair()

            node.set_val('crypto_escrow_pub_key', crypto_escrow_pub_key)

            if  tid != 1 and root_tenant_node.get_val('crypto_escrow_pub_key'):
                node.set_val('crypto_escrow_prv_key', Base64Encoder.encode(GCE.asymmetric_encrypt(root_tenant_node.get_val('crypto_escrow_pub_key'), crypto_escrow_prv_key)))

    if not request['skip_admin_account_creation']:
        admin_desc = models.User().dict(language)
        admin_desc['username'] = request['admin_username']
        admin_desc['name'] = request['admin_name']
        admin_desc['password'] = request['admin_password']
        admin_desc['name'] = request['admin_name']
        admin_desc['mail_address'] = request['admin_mail_address']
        admin_desc['language'] = language
        admin_desc['role'] = 'admin'
        admin_desc['pgp_key_remove'] = False
        admin_user = db_create_user(session, tid, None, admin_desc, language)
        admin_user.password_change_needed = (tid != 1)

        if encryption and escrow:
            node.set_val('crypto_escrow_pub_key', crypto_escrow_pub_key)
            admin_user.crypto_escrow_prv_key = Base64Encoder.encode(GCE.asymmetric_encrypt(admin_user.crypto_pub_key, crypto_escrow_prv_key))

    if not request['skip_recipient_account_creation']:
        receiver_desc = models.User().dict(language)
        receiver_desc['username'] = request['receiver_username']
        receiver_desc['name'] = request['receiver_name']
        receiver_desc['password'] = request['receiver_password']
        receiver_desc['mail_address'] = request['receiver_mail_address']
        receiver_desc['language'] = language
        receiver_desc['role'] = 'receiver'
        receiver_desc['pgp_key_remove'] = False
        receiver_desc['send_account_activation_link'] = False
        receiver_user = db_create_user(session, tid, None, receiver_desc, language)
        receiver_user.password_change_needed = (tid != 1)

    context_desc = models.Context().dict(language)
    context_desc['name'] = 'Default'
    context_desc['status'] = 'enabled'

    if not request['skip_recipient_account_creation']:
        context_desc['receivers'] = [receiver_user.id]
    else:
        context_desc['receivers'] = []

    context = db_create_context(session, tid, None, context_desc, language)

    # Root tenants initialization terminates here

    if tid == 1:
        db_refresh_tenant_cache(session, [tid])
        return

    # Secondary tenants initialization starts here

    mode = node.get_val('mode')

    if mode != 'default':
        node.set_val('hostname', node.get_val('subdomain') + '.' + root_tenant_node.get_val('rootdomain'))
        node.set_val('tor', False)

    if mode in ['whistleblowing.it', 'eat']:
        for varname in ['anonymize_outgoing_connections',
                        'password_change_period',
                        'default_questionnaire']:
            node.set_val(varname, root_tenant_node.get_val(varname))

        context.questionnaire_id = root_tenant_node.get_val('default_questionnaire')

        # Set data retention policy to 18 months
        context.tip_timetolive = 540

        # Delete the admin user
        request['admin_password'] = ''
        session.delete(admin_user)

        if not request['skip_recipient_account_creation']:
            receiver_user.can_edit_general_settings = True

            # Set the recipient name equal to the node name
            receiver_user.name = receiver_user.public_name = request['node_name']

    # Apply the specific fixes related to whistleblowing.it projects
    if mode == 'whistleblowing.it':
        node.set_val('simplified_login', True)

    db_refresh_tenant_cache(session, [tid])


class Wizard(BaseHandler):
    """
    Setup Wizard handler
    """
    check_roles = 'any'
    invalidate_cache = True

    def post(self):
        request = self.validate_request(self.request.content.read(),
                                        requests.WizardDesc)

        if self.request.hostname not in self.state.tenant_hostname_id_map:
            hostname = self.request.hostname
        else:
            hostname = ''

        return tw(db_wizard, self.request.tid, hostname, request)
