1. Определить алгоритм с наилучшим сжатием
```
[root@zfs ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk
`-sda1   8:1    0   40G  0 part /
sdb      8:16   0  512M  0 disk
sdc      8:32   0  512M  0 disk
sdd      8:48   0  512M  0 disk
sde      8:64   0  512M  0 disk
sdf      8:80   0  512M  0 disk
sdg      8:96   0  512M  0 disk
sdh      8:112  0  512M  0 disk
sdi      8:128  0  512M  0 disk
```
Создаем 4 пула для тестов с разным сжатием:
```
zpool create zfs1 mirror /dev/sdb /dev/sdc 
zpool create zfs2 mirror /dev/sdd /dev/sde 
zpool create zfs3 mirror /dev/sdf /dev/sdg 
zpool create zfs4 mirror /dev/sdh /dev/sdi


zfs set compression=lzjb zfs1
zfs set compression=lz4 zfs2
zfs set compression=gzip-9 zfs3
zfs set compression=zle zfs4
```
Скачиваем файл и копируем в каждый пул:
```
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8

[root@zfs /]# ls -l /zfs*
/zfs1:
total 2443
-rw-r--r--. 1 root root 3359372 Dec 10 22:43 War_and_Peace.txt

/zfs2:
total 2041
-rw-r--r--. 1 root root 3359372 Dec 10 22:43 War_and_Peace.txt

/zfs3:
total 1239
-rw-r--r--. 1 root root 3359372 Dec 10 22:43 War_and_Peace.txt

/zfs4:
total 3287
-rw-r--r--. 1 root root 3359372 Dec 10 22:43 War_and_Peace.txt

[root@zfs /]# zfs list
NAME   USED  AVAIL     REFER  MOUNTPOINT
zfs1  2.48M   350M     2.41M  /zfs1
zfs2  2.09M   350M     2.02M  /zfs2
zfs3  1.30M   351M     1.23M  /zfs3
zfs4  3.30M   349M     3.23M  /zfs4

[root@zfs /]# zfs get all | grep compressratio | grep -v ref
zfs1  compressratio         1.35x                  -
zfs2  compressratio         1.62x                  -
zfs3  compressratio         2.64x                  -
zfs4  compressratio         1.01x                  -
```
Видим что лучший метод - gzip-9

2.  Определение настроек пула

Скачиваем и распаковываем архив
```
wget -O archive.tar.gz --no-check-certificate https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download

[root@zfs /]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb

[root@zfs /]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                    ONLINE
	  mirror-0              ONLINE
	    /zpoolexport/filea  ONLINE
	    /zpoolexport/fileb  ONLINE
```
Импортируем
```
zpool import -d zpoolexport/ otus

[root@zfs /]# zpool status
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                    STATE     READ WRITE CKSUM
	otus                    ONLINE       0     0     0
	  mirror-0              ONLINE       0     0     0
	    /zpoolexport/filea  ONLINE       0     0     0
	    /zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```
Запрос сразу всех параметров пула:
```
[root@zfs /]# zpool get all otus
NAME  PROPERTY                       VALUE                          SOURCE
otus  size                           480M                           -
otus  capacity                       0%                             -
otus  altroot                        -                              default
otus  health                         ONLINE                         -
otus  guid                           6554193320433390805            -
otus  version                        -                              default
otus  bootfs                         -                              default
otus  delegation                     on                             default
otus  autoreplace                    off                            default
otus  cachefile                      -                              default
otus  failmode                       wait                           default
otus  listsnapshots                  off                            default
otus  autoexpand                     off                            default
otus  dedupditto                     0                              default
otus  dedupratio                     1.00x                          -
otus  free                           478M                           -
otus  allocated                      2.09M                          -
otus  readonly                       off                            -
otus  ashift                         0                              default
otus  comment                        -                              default
otus  expandsize                     -                              -
otus  freeing                        0                              -
otus  fragmentation                  0%                             -
otus  leaked                         0                              -
otus  multihost                      off                            default
otus  checkpoint                     -                              -
otus  load_guid                      12439983816042870417           -
otus  autotrim                       off                            default
otus  feature@async_destroy          enabled                        local
otus  feature@empty_bpobj            active                         local
otus  feature@lz4_compress           active                         local
otus  feature@multi_vdev_crash_dump  enabled                        local
otus  feature@spacemap_histogram     active                         local
otus  feature@enabled_txg            active                         local
otus  feature@hole_birth             active                         local
otus  feature@extensible_dataset     active                         local
otus  feature@embedded_data          active                         local
otus  feature@bookmarks              enabled                        local
otus  feature@filesystem_limits      enabled                        local
otus  feature@large_blocks           enabled                        local
otus  feature@large_dnode            enabled                        local
otus  feature@sha512                 enabled                        local
otus  feature@skein                  enabled                        local
otus  feature@edonr                  enabled                        local
otus  feature@userobj_accounting     active                         local
otus  feature@encryption             enabled                        local
otus  feature@project_quota          active                         local
otus  feature@device_removal         enabled                        local
otus  feature@obsolete_counts        enabled                        local
otus  feature@zpool_checkpoint       enabled                        local
otus  feature@spacemap_v2            active                         local
otus  feature@allocation_classes     enabled                        local
otus  feature@resilver_defer         enabled                        local
otus  feature@bookmark_v2            enabled                        local
```

Запрос сразу всех параметром файловой системы:
```
[root@zfs /]# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.02M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1021K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              off                    default
otus  redundant_metadata    all                    default
otus  overlay               off                    default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default
```
Командами посмотрел отдельные параметры
```
zfs get available otus
zfs get readonly otus
zfs get recordsize otus
zfs get compression otus
zfs get checksum otus
```
3. Работа со снапшотом, поиск сообщения от преподавателя

Скачиваем снапшот
```
wget -O otus_task2.file --no-check-certificate https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download
```
Восстанавливаем снапшот
```
zfs receive otus/test@today < otus_task2.file
```
Ищем файл
```
[root@zfs otus]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message
```
в файле ссылка на git https://github.com/sindresorhus/awesome
