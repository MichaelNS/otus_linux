#!/bin/bash

set -x

# remove the temp volume

lvremove -y /dev/vg_root/lv_root
vgremove -y /dev/vg_root
pvremove -y /dev/sdb


# test LVM snapshots
# ------------------

# allocate a volume for /home

lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home

# move home data to the new volume

mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "$(blkid /dev/VolGroup00/LogVol_Home | cut -d' ' -f2) /home xfs defaults 0 0" >> /etc/fstab

# generate a number of files
touch /home/file{1..20}
ls /home

#take a snapshot of the /home volume
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home

#remove some files
rm -f /home/file{11..20}
ls /home

# restore files from the snapshot
umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home
ls /home

