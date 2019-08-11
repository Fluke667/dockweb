FROM fluke667/alpine:latest
FROM node:alpine3.10 as node-builder
FROM nginx:alpine3.10 as web-builder
FROM golang:1.12-alpine3.10 as go-builder

         
apk update && apk add --no-cache \ 
         openssl curl ca-certificates ffmpeg libressl libsmbclient libxml2 re2c \
         
         nginx
         
apk update && apk add --no-cache \ 
         php7-pecl-mcrypt php7-pecl-ssh2 php7-pecl-igbinary php7-pear php7-fpm php7-bcmath php7-ctype php7-curl php7-dom php7-exif php7-fileinfo \
         php7-gmp php7-iconv php7-imagick php7-json php7-mbstring php7-mysqli php7-opcache php7-openssl php7-ftp php7-gd \
         php7-phar php7-posix php7-session php7-simplexml php7-soap php7-sodium php7-sockets php7-tokenizer php7-imap \
         php7-xml php7-xmlreader php7-xmlwriter php7-zip php7-zlib php7-apcu php7-bz2 php7-cli php7-intl php7-ldap php7-mcrypt \
         php7-memcached php7-pcntl php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pdo_sqlite php7-redis php7-sqlite3 \
         python3 su-exec tzdata composer && \
         
apk update && apk add --no-cache --virtual build-deps \ 
         gd-dev geoip-dev libmaxminddb-dev libxml2-dev libxslt-dev linux-headers openssl-dev paxmark pcre-dev perl-dev pkgconf \
         zlib-dev gcc libc-dev make libedit-dev mercurial alpine-sdk findutils curl gnupg1 autoconf automake build-base gnupg \
         libtool php7-dev samba-dev tar wget freetype-dev icu-dev libevent-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev \
         libmemcached-dev libzip-dev openldap-dev postgresql-dev imagemagick-dev libwebp-dev \
         
         
         
# Expose the ports for nginx
EXPOSE 80 443

VOLUME ["/var/www/nextcloud"]


ADD config /config


COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
