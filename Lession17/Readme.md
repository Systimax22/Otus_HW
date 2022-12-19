## Создайте свой кастомный образ nginx на базе alpine.

Создаем образ и копируем необходимые файлы для тестового задания:

````
Dockerfile:

FROM alpine:latest
RUN	apk update && \
	apk upgrade && \
    apk add nginx && \
    mkdir /www
    COPY etc/nginx.conf /etc/nginx/nginx.conf
    COPY etc/conf.d/default.conf /etc/nginx/conf.d/default.conf
    ADD index.html /usr/share/nginx/html/index.html
    ADD info.php /usr/share/nginx/html/info.php

    EXPOSE 8080

    ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
````
Проверяем что все работает, заливаем в репо.

Образ залит в репо:
````
https://hub.docker.com/layers/systimax/otustest/nginx/images/sha256-dca10d73c0dbe57d048517272ca77d82022fe0dfe14fbc1f5a7c601d818d472c?context=repo
````
Запуск:

````
docker run -d -p 8080:8080 systimax/otustest:nginx
````

Проверка работы - http://127.0.0.1:8080


## Определите разницу между контейнером и образом

Образ Docker (Docker Image) - это неизменяемый файл, содержащий исходный код, библиотеки, зависимости, инструменты и другие файлы, необходимые для запуска приложения.

Контейнер Docker (Docker Container) - это виртуализированная среда выполнения, в которой пользователи могут изолировать приложения от хостовой системы.

## Можно ли в контейнере собрать ядро? 
Контейнер не имеет собственного ядра, и использует ядро хост-системы. В теории, собрав контейнер со средой для сборки ядра, можно, но зачем?


## Задание со * (звездочкой) - Создайте кастомные образы nginx и php, объедините их в docker-compose.

Создаем образ nginx и копируем необходимые файлы для тестового задания:

````
Dockerfile:

    FROM nginx:alpine  
    COPY ./default.conf /etc/nginx/conf.d/default.conf
    ENTRYPOINT ["nginx", "-g", "daemon off;"]
````
Создаем образ php
````
Dockerfile:

FROM php:7.4-fpm-alpine
WORKDIR /var/www/html
RUN apk update && apk add --no-cache \
build-base shadow vim curl \
php \
php-fpm \
php-common
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
CMD ["php-fpm"]
````

Все заливаем в репо:
https://hub.docker.com/layers/systimax/otustest/docker-nginx-php/images/sha256-cad666687fc68117efe427935df1a360fe6b8b2a890ad7a5c0f05278add589ba?context=repo
https://hub.docker.com/layers/systimax/otustest/docker-php/images/sha256-80b93aa60a8c190c1b5ca96b316a9ddd95face5a8cd0509eaa1b76a08586bfa1?context=repo

Создаем docker-compose:
````
version: '3'
services:
  nginx:
    image: systimax/otustest:docker-nginx-php
    container_name: nginx-container
    ports:
      - 80:80
    links:
      - php
    volumes:
          - ./www/html/:/var/www/html/
   

  php:
    image: systimax/otustest:docker-php
    container_name: php-container
    
    #ports:
    #   – 9000
    volumes:
          - ./www/html/:/var/www/html/
````

Запускаем docker-compose up -d из директории nginx-php и проверяем http://127.0.0.1