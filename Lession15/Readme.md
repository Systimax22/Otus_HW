## Подготовить стенд на Vagrant как минимум с одним сервером. 

Описание/Пошаговая инструкция выполнения домашнего задания:
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:

необходимо использовать модуль yum/apt;
конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными;
после установки nginx должен быть в режиме enabled в systemd;
должен быть использован notify для старта nginx после установки;
сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible.




Запускаем стенд

````
vagrant up
````

Ждем отработки provisioner: ansible

````
==> otus: Running provisioner: ansible...
    otus: Running ansible-playbook...

PLAY [otus] ********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [otus]

TASK [nginx : install required packages] ***************************************
changed: [otus] => (item=epel-release)
changed: [otus] => (item=nginx)

TASK [nginx : copy nginx configuration file] ***********************************
changed: [otus]

TASK [nginx : enable nginx] ****************************************************
changed: [otus]

RUNNING HANDLER [nginx : restart nginx] ****************************************
changed: [otus]

PLAY RECAP *********************************************************************
otus                       : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
````

Открываем ссылку http://127.0.0.1:8080/ и видим дефолтную страницу

В access.log Nginx видно обращения на порт 8080.
````
[root@otus ~]# tail /var/log/nginx/access.log
10.0.2.2 - - [15/Dec/2022:22:09:10 +0000] "GET / HTTP/1.1" 200 4833 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" "-"
10.0.2.2 - - [15/Dec/2022:22:09:10 +0000] "GET /img/centos-logo.png HTTP/1.1" 200 3030 "http://127.0.0.1:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" "-"
10.0.2.2 - - [15/Dec/2022:22:09:10 +0000] "GET /img/html-background.png HTTP/1.1" 200 1801 "http://127.0.0.1:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" "-"
10.0.2.2 - - [15/Dec/2022:22:09:10 +0000] "GET /img/header-background.png HTTP/1.1" 200 82896 "http://127.0.0.1:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" "-"
10.0.2.2 - - [15/Dec/2022:22:09:11 +0000] "GET /favicon.ico HTTP/1.1" 404 3650 "http://127.0.0.1:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" "-"
````

