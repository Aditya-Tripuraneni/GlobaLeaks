#!/bin/bash -x
set -e

echo "Running Build & Install"
distro="$(lsb_release -cs)"
sudo apt-get -y update

sudo apt-get -y install curl git debhelper devscripts dh-apparmor dh-python python python-pip python-setuptools python-sphinx

if [ $distro = "bionic" ]; then
  sudo apt-get -y install python3-pip python3-setuptools python3-sphinx
fi

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get -y install nodejs
cd /build/GlobaLeaks
sed -ie 's/key_bits = 2048/key_bits = 512/g' backend/globaleaks/settings.py
sed -ie 's/csr_sign_bits = 512/csr_sign_bits = 256/g' backend/globaleaks/settings.py
rm debian/control backend/requirements.txt

cat >debian/changelog <<EOL
globaleaks (6.6.6) stable; urgency=medium

  * GlobaLeaks CI package

 -- GlobaLeaks software signing key <info@globaleaks.org>  Wed, 30 May 2018 14:19:43 +0200
EOL

cp debian/controlX/control.$distro debian/control
cp backend/requirements/requirements-$distro.txt backend/requirements.txt
cd client
npm install grunt-cli
npm install -d
./node_modules/.bin/grunt build
cd ..
debuild -i -us -uc -b
sudo mkdir -p /globaleaks/deb/
sudo cp ../globaleaks*deb /globaleaks/deb/

sudo curl https://deb.globaleaks.org/bionic/python-josepy_1.1.0-2~bpo9%2b1_all.deb --output /globaleaks/deb/python-josepy_1.1.0-2~bpo9%2b1_all.deb
sudo curl https://deb.globaleaks.org/bionic/python3-josepy_1.1.0-2~bpo9%2b1_all.deb --output /globaleaks/deb/python3-josepy_1.1.0-2~bpo9%2b1_all.deb
sudo curl https://deb.globaleaks.org/bionic/python-acme_0.28.0-1~bpo9%2b1_all.deb --output /globaleaks/deb/python-acme_0.28.0-1~bpo9%2b1_all.deb
sudo curl https://deb.globaleaks.org/bionic/python3-acme_0.28.0-1~bpo9%2B1_all.deb --output /globaleaks/deb/python3-acme_0.28.0-1~bpo9%2B1_all.deb

#!/bin/bash -x
if [ `uname -m` = 'x86_64' ]; then
  sudo curl https://deb.globaleaks.org/bionic/libsodium23_1.0.16-2~bpo9%2b1_amd64.deb --output /globaleaks/deb/libsodium23_1.0.16-2~bpo9%2b1_amd64.deb
  sudo curl https://deb.globaleaks.org/bionic/python-nacl_1.2.1-3~bpo9+3_amd64.deb --output /globaleaks/deb/python-nacl_1.2.1-3~bpo9+3_amd64.deb
  sudo curl https://deb.globaleaks.org/bionic/python3-nacl_1.2.1-3~bpo9+3_amd64.deb --output /globaleaks/deb/python3-nacl_1.2.1-3~bpo9+3_amd64.deb
else
  sudo curl https://deb.globaleaks.org/bionic/libsodium23_1.0.16-2~bpo9%2b1_i386.deb --output /globaleaks/deb/libsodium23_1.0.16-2~bpo9%2b1_i386.deb
  sudo curl https://deb.globaleaks.org/bionic/python-nacl_1.2.1-3~bpo9+3_i386.deb --output /globaleaks/deb/python-nacl_1.2.1-3~bpo9+3_i386.deb
  sudo curl https://deb.globaleaks.org/bionic/python3-nacl_1.2.1-3~bpo9+3_i386.deb --output /globaleaks/deb/python3-nacl_1.2.1-3~bpo9+3_i386.deb
fi

sudo ./scripts/install.sh --assume-yes --test
