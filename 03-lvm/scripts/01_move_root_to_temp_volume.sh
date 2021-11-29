#!/bin/bash

set -x
yum install xfsdump -y

# reducing the volume to 8G - stage 1
# -----------------------------------

# create a temporary volume

pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt

# move data to the volume and make it bootable

xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/ << EOF
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done
sed -i "s:rd.lvm.lv=VolGroup00/LogVol01:rd.lvm.lv=vg_root/lv_root:" /boot/grub2/grub.cfg
EOF

