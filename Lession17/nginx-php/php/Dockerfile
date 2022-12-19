FROM php:7.4-fpm-alpine
WORKDIR /var/www/html
RUN apk update && apk add --no-cache \
build-base shadow vim curl \
php \
php-fpm \
php-common
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
CMD ["php-fpm"]