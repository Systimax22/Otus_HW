В репозитории Vagrant файл, после запуска:

vagrant ssh
sudo -i
## Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).


Вывод service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова
tail -f /var/log/messages

````
[root@otus ~]# tail -f /var/log/messages
Dec 15 01:01:01 localhost systemd: Started Session 4 of user root.
Dec 15 01:01:14 localhost systemd: Starting My watchlog service...
Dec 15 01:01:14 localhost root: Thu Dec 15 01:01:14 UTC 2022: World found!
Dec 15 01:01:14 localhost systemd: Started My watchlog service.
````
## Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).

Вывод - systemctl status spawn-fcgi
````
[root@otus ~]# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-12-15 01:00:41 UTC; 5min ago
 Main PID: 4958 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─4958 /usr/bin/php-cgi
           ├─4960 /usr/bin/php-cgi
           ├─4961 /usr/bin/php-cgi
           ├─4962 /usr/bin/php-cgi
           ├─4963 /usr/bin/php-cgi
           ├─4964 /usr/bin/php-cgi
           ├─4965 /usr/bin/php-cgi
           ├─4966 /usr/bin/php-cgi
           ├─4967 /usr/bin/php-cgi
           ├─4968 /usr/bin/php-cgi
           ├─4969 /usr/bin/php-cgi
           ├─4970 /usr/bin/php-cgi
           ├─4971 /usr/bin/php-cgi
           ├─4972 /usr/bin/php-cgi
           ├─4973 /usr/bin/php-cgi
           ├─4974 /usr/bin/php-cgi
           ├─4975 /usr/bin/php-cgi
           ├─4976 /usr/bin/php-cgi
           ├─4977 /usr/bin/php-cgi
           ├─4978 /usr/bin/php-cgi
           ├─4979 /usr/bin/php-cgi
           ├─4980 /usr/bin/php-cgi
           ├─4981 /usr/bin/php-cgi
           ├─4982 /usr/bin/php-cgi
           ├─4983 /usr/bin/php-cgi
           ├─4984 /usr/bin/php-cgi
           ├─4985 /usr/bin/php-cgi
           ├─4986 /usr/bin/php-cgi
           ├─4987 /usr/bin/php-cgi
           ├─4988 /usr/bin/php-cgi
           ├─4989 /usr/bin/php-cgi
           ├─4990 /usr/bin/php-cgi
           └─4991 /usr/bin/php-cgi

Dec 15 01:00:41 otus systemd[1]: Started Spawn-fcgi startup service by Otus.
````

## Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.

Вывод ss -tnulp | grep httpd

````
[root@otus system]# ss -tnulp | grep httpd
tcp    LISTEN     0      128    [::]:80                 [::]:*                   users:(("httpd",pid=6048,fd=4),("httpd",pid=6047,fd=4),("httpd",pid=6046,fd=4),("httpd",pid=6045,fd=4),("httpd",pid=6044,fd=4),("httpd",pid=6043,fd=4))
tcp    LISTEN     0      128    [::]:8080               [::]:*                   users:(("httpd",pid=5699,fd=4),("httpd",pid=5698,fd=4),("httpd",pid=5697,fd=4),("httpd",pid=5696,fd=4),("httpd",pid=5695,fd=4),("httpd",pid=5694,fd=4))
tcp    LISTEN     0      128    [::]:8081               [::]:*                   users:(("httpd",pid=5798,fd=4),("httpd",pid=5797,fd=4),("httpd",pid=5796,fd=4),("httpd",pid=5795,fd=4),("httpd",pid=5794,fd=4),("httpd",pid=5793,fd=4))
````


## Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.


````
touch /lib/systemd/system/jira.service
chmod 664 /lib/systemd/system/jira.service

vi /lib/systemd/system/jira.service

[Unit] 
Description=Atlassian Jira
After=network.target

[Service] 
Type=forking
User=jira
LimitNOFILE=20000
PIDFile=/opt/atlassian/jira/work/catalina.pid
ExecStart=/opt/atlassian/jira/bin/start-jira.sh
ExecStop=/opt/atlassian/jira/bin/stop-jira.sh

[Install] 
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable jira.service
systemctl start jira.service
systemctl status jira.service
````
