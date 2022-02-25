# Установить систему с LVM, после чего переименовать VG
- Первым делом посмотрим текущее состояние системы:
```
[root@lvm vagrant]# vgs
  VG         #PV #LV #SN Attr   VSize   VFree
  VolGroup00   1   2   0 wz--n- <38.97g    0 
```

Приступим к переименованию:
```bash
vgrename VolGroup00 OtusRoot
```

Далее правим /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg. Везде заменяем старое
название на новое. По ссылкам можно увидеть примеры получившихся файлов.
 - `vi /etc/default/grub` меняем названия
 - `vi /boot/grub2/grub.cfg` меняем название в разделе `linux16`
 - `vi /etc/fstab` меняем названия

```bash
sed -i 's/VolGroup00/OtusRoot/g' /etc/default/grub && sed -i 's/VolGroup00/OtusRoot/g' /boot/grub2/grub.cfg && sed -i 's/VolGroup00/OtusRoot/g' /etc/fstab
```

Пересоздаем initrd image, чтобы он знал новое название Volume Group
 - `mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`
 - `reboot`
 - `sudo lvs`

```bash
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

reboot
sudo lvs

```

Если перезагрузка выполнена успешно, то значит все было сделано правильно
Дополнительно проверяем результат:
```
[vagrant@lvm ~]$ sudo vgs
  VG       #PV #LV #SN Attr   VSize   VFree
  OtusRoot   1   2   0 wz--n- <38.97g    0 
```


Полный список команд bash
```bash
sudo su -

lvmdiskscan

vgs

vgrename VolGroup00 OtusRoot

ls -l /dev/mapper

sed -i 's/VolGroup00/OtusRoot/g' /etc/default/grub
sed -i 's/VolGroup00/OtusRoot/g' /boot/grub2/grub.cfg
sed -i 's/VolGroup00/OtusRoot/g' /etc/fstab

mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

reboot
sudo lvs

```
