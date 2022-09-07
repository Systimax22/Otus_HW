Сервер:

Устанавливаем утилиты NFS
yum install nfs-utils

включаем firewall
systemctl enable firewalld --now
systemctl status firewalld


Открываем  доступ к сервисам NFS

[root@nfss ~]# firewall-cmd --add-service="nfs3" \
>             --add-service="rpc-bind" \
>              --add-service="mountd" \
>              --permanent
success
[root@nfss ~]# firewall-cmd --reload
success
Проверил открытые порты ss -tnplu


Создал папку /srv/share/upload, сменил владельца и права на неё 

mkdir -p /srv/share/upload 
chown -R nfsnobody:nfsnobody 
/srv/share chmod 0777 
/srv/share/upload

В файле /etc/exports указал, какие папки будут расшарены 
cat /etc/exports /srv/share 192.168.50.11/32(rw,sync,root_squash)

Экспортировал директорию 
/srv/share/upload exportfs -r

Клиент: 

Установил необходимое ПО yum install nfs-utils

Включил firewall и проверил, что он запущен systemctl enable filewalld --now

Изменил /etc/fstab для автоматического монтирования 

echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x- systemd.automount 0 0" >> /etc/fstab

Перезагрузил службу для подмонтрирования директории 

systemctl daemon-reload systemctl restart remote-fs.target

Проверил успешное монтирование mount | grep mnt


Добавил в Vagrantfile  для запуска shell скрипта при первом запуске 

nfss.vm.provision "shell", path: "srv_script.sh" nfsc.vm.provision "shell", path: "client_script.sh"
