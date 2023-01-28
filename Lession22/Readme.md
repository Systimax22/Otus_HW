## Запретить всем пользователям, кроме группы admin логин в выходные(суббота и воскресенье), без учета праздников
Добавляем группу admin
sudo groupadd admin

Далее в группу admin добавить пользователей которым будет необходим доступ в выходные

sudo usermod -aG admin systimax

Добавляем в файл /etc/pam.d/sshd строку:

auth       required     pam_script.so

В файл /etc/pam_script добавляем код проверки на группу и день недели. Если пользователь в группе  admin - пускаем, если нет - проверяем день недели.

#!/bin/bash
'''
if [[ `grep $PAM_USER /etc/group | grep 'admin'` ]]
then
exit 0
fi
if [[ `date +%u` > 5 ]]
then
exit 1
fi






## дать конкретному пользователю права работать с докером

На уже настроенной системе, проверяем наличие группы docker

systimax@mail:~$ cat /etc/group|grep docker
docker:x:112:

Пробуем выполнить команду от пользователя который не в группе docker:

systimax@mail:~$ docker ps
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied

Добавляем пользователя в группу docker:

sudo usermod -aG docker systimax

Перелогиниваемся, и прверяем:

systimax@mail:~$ docker ps
CONTAINER ID   IMAGE             COMMAND           CREATED       STATUS       PORTS                                                                                                                                                                                                                                                              NAMES
45fcda322fe6   mail:rc5.ipa   "/sbin/my_init"   7 weeks ago   Up 4 weeks   0.0.0.0:25->25/tcp, 0.0.0.0:53->53/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:110->110/tcp, 0.0.0.0:143->143/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:465->465/tcp, 0.0.0.0:587->587/tcp, 0.0.0.0:993->993/tcp, 0.0.0.0:8083->8083/tcp, 0.0.0.0:53->53/udp, 0.0.0.0:2222->22/tcp   mail.rc5.ipa