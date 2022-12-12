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

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/2.png "Смена пароля rd.break")

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
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r) --force
![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/5.png "Переименование VG")

Перезагружаемся, вводим vgs и видим название VG otus

## Добавить свой модуль в initrd
Создаем директорию mkdir /usr/lib/dracut/modules.d/01test
Помещаем 2 скрипта 
module-setup.sh
test.sh
пересобираем initrd
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
отключаем опции rghb и quiet при загрузке

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/7.png "Переименование VG")


