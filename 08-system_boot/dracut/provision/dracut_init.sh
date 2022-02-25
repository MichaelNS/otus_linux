#!/bin/bash

mkdir /usr/lib/dracut/modules.d/01test
cd /usr/lib/dracut/modules.d/01test || exit

#------------------------------------------------
cp /vagrant/provision/module-setup.sh /usr/lib/dracut/modules.d/01test
chmod +x module-setup.sh

#------------------------------------------------

cp /vagrant/provision/test.sh /usr/lib/dracut/modules.d/01test
chmod +x test.sh

mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
