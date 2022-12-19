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