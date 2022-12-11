yum update
[root@otus home]# yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc docker

исходники nginx:
[root@otus home]# wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.22.1-1.el7.ngx.src.rpm
[root@otus home]# rpm -i nginx-1.22.1-1.el7.ngx.src.rpm

Собираем пакет:
[root@otus home]# rpmbuild -bb rpmbuild/SPECS/nginx.spec

Копируем файл в папку будущего репозитория:
[root@otus home]# mkdir /srv/nginx/x86_64
[root@otus home]# cp /root/rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm /srv/nginx/x86_64

Поднимаем nginx в докере:
[root@otus /]# service docker start
Redirecting to /bin/systemctl start docker.service
[root@otus /]# docker run --name nginx -v /srv/nginx/:/usr/share/nginx/html -p 80:80 -d nginx
Unable to find image 'nginx:latest' locally
Trying to pull repository docker.io/library/nginx ...
latest: Pulling from docker.io/library/nginx
025c56f98b67: Pull complete
ca9c7f45d396: Pull complete
ed6bd111fc08: Pull complete
e25b13a5f70d: Pull complete
9bbabac55ab6: Pull complete
e5c9ba265ded: Pull complete
Digest: sha256:ab589a3c466e347b1c0573be23356676df90cd7ce2dbf6ec332a5f0a8b5e59db
Status: Downloaded newer image for docker.io/nginx:latest
8b1119ef5a7f2638885c585e7dc07b2d06d7eef7d838d4058c18393c95468e17

[root@otus ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
41f193d44a21        nginx               "/docker-entrypoin..."   22 minutes ago      Up 22 minutes       0.0.0.0:80->80/tcp   nginx

Включаем в nginx опцию autoindex on;
[root@otus ~]# docker exec -it nginx bash


Создаем окружение для репозитория:

[root@otus yum.repos.d]# createrepo /srv/nginx/x86_64/
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 0 pkgs
Spawning worker 2 with 0 pkgs
Spawning worker 3 with 0 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete

[root@otus yum.repos.d]# yum repolist enabled
Загружены модули: fastestmirror, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
 * base: mirrors.datahouse.ru
 * extras: mirror.docker.ru
 * updates: mirror.sale-dedic.com
Идентификатор репозитория                                                                        репозиторий                                                                                состояние
base/7/x86_64                                                                                    CentOS-7 - Base                                                                            10 072
extras/7/x86_64                                                                                  CentOS-7 - Extras                                                                             515
local                                                                                            OtusHW-Base                                                                                     1
updates/7/x86_64                                                                                 CentOS-7 - Updates                                                                          4 425
repolist: 15 013



