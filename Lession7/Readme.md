SSH до виртуалбокса строить было лень, поэтому скриншотами.

В начале загрузки, нажимаем "e" и редактируем параметры загрузчика, добавляем init=/bin/bash


## Способ 1.


![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/1.png "Редактирование")

Выходим через ctrl+x, загружаемся, получаем шелл с правами root, монтируем ФС в режиме чтение/запись, создаем файл /.autorelabel для Selinux, меняем пароль.

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/2.png "Смена пароля")

После 2х перезагрузок, попадаем в систему с новым паролем.
В загрузчике можно сразу указать опцию rw.

## Способ 2.

    Добавляем rd.break, после загрузки делаем chroot /sysroot/ + все действия как в способе 1.

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/3.png "Смена пароля rd.break")

## Способ 3.

Добавляем init=/sysroot/bin/bash, дальше все как в способе 2.
![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/4.png "Смена пароля sysroot")


## Переименовать VG.
Командами vgs, lvs получаем информацию о VG и томам в этой группе, дальше переименовываем VG командой vgrename, правим:
/etc/fstab
/etc/default/grub
/etc/grub2-efi.cfg
Обновляем аттрибуты vgchange -ay
Обновляем initrd 
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/5.png "Переименование VG")

Перезагружаемся, вводим vgs и видим название VG otus

## Добавить свой модуль в initrd.
Создаем директорию mkdir /usr/lib/dracut/modules.d/01test
Помещаем 2 скрипта 
module-setup.sh
test.sh
пересобираем initrd
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
отключаем опции rghb и quiet при загрузке

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/7.png "модуль")


## Сконфигурировать систему без отдельного раздела с /boot, а только с LVM.

Добавляем диск в Virtualbox, fdisk -l, видим диск sdb, потом
parted

select /dev/sdb

mklabel msdos

mkpart 0 5GB

pvcreate /dev/sdb1/ --bootloaderareasize 1M

vgcreate newotus /dev/sdb1

lvcreate -n root -l 100%FREE newotus


![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/8.png "grub")

Дальше случился тупик, потому что "Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/"
не доступен.

Но шаги такие:

смонтировать новый раздел в /mnt/newdisk, дальше rsync корень и boot, mount --rbind /dev, /proc, /sys, /run
chroot /mnt/newdisk

добавить репо который не работает через yum-config-manager, установить патченный grub
поправить fstab, создать новый конфиг grub, пересобрать initrd, установить grub на /dev/sdb




