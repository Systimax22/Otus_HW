Устанавливаем необходимые пакеты

[vagrant@kernel-update ~]$ vagrant up --provider=virtualbox
[vagrant@kernel-update ~]$ vagrant ssh

[vagrant@kernel-update ~]$ uname -r
3.10.0-1127.el7.x86_64


[vagrant@kernel-update ~]$ cd /usr/src/kernels/

[vagrant@kernel-update ~]$ sudo wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.8.tar.xz

[vagrant@kernel-update ~]$ sudo tar -xvf linux-5.19.8.tar.xz

[vagrant@kernel-update ~]$ cd linux-5.19.8

Кипирую конфиг ядра системы

[vagrant@kernel-update ~]$ sudo cp -v /boot/config-3.10.0-1127.el7.x86_64 ./.config
[vagrant@kernel-update ~]$ sudo make olddefconfig

[vagrant@kernel-update linux-5.19.8]$ sudo make olddefconfig
***
*** Compiler is too old.
***   Your GCC version:    4.8.5
***   Minimum GCC version: 5.1.0
***
scripts/Kconfig.include:44: Sorry, this compiler is not supported.

Ставим devtoolset-7-gcc
[vagrant@kernel-update ~]$ yum install centos-release-scl
sudo yum install devtoolset-7-gcc*
scl enable devtoolset-7 bash

Проверяем

[vagrant@kernel-update ~]$ gcc -v

gcc version 7.3.1 20180303 (Red Hat 7.3.1-5) (GCC)

Применяем конфин
[vagrant@kernel-update ~]$ sudo make olddefconfig

[vagrant@kernel-update ~]$ sudo make menuconfig

Можно выключить то что точно не нужно (видеокарты, драйвера), не стал =)

собираем ядро в 4 потока (процессор больше не умеет)

[vagrant@kernel-update linux-5.19.8]$ sudo make -j4

sudo make -j4 modules_install
[vagrant@kernel-update ~]$ [vagrant@kernel-update ~]$ sudo make -j4 headers_install
[vagrant@kernel-update ~]$ sudo make -j4 install

Добавляем новое ядро в GRUB

[vagrant@kernel-update ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$ sudo reboot

[vagrant@kernel-update ~]$ uname -r
5.19.8


Узнаем имя

systimax@systimax:~/otus1/manual_kernel_update/packer$ vboxmanage list runningvms
"manual_kernel_update_kernel-update_1663179123633_42786" {c4253293-091a-4582-a0bb-61de3ab1c497}

Создаем образ

vagrant package --base manual_kernel_update_kernel-update_1663179123633_42786 --output centos-7-5-kolov.box

публикуем образ в облако

vagrant cloud publish --release systimax/centos-7-5 1.0 virtualbox centos-7-5-kolov.box

Инициализируем образ

vagrant box add --name centos-7-5 centos-7-5-kolov.box
vagrant box list
centos-7-5 (virtualbox, 0)
vagrant init centos-7-5
vagrant up
vagrant ssh

[vagrant@kernel-update ~]$ uname -r
5.19.8

