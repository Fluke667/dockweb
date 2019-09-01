FROM fluke667/alpine-java AS java
FROM fluke667/alpine-golang:latest AS go
#FROM node:10.15-alpine AS nodejs
FROM node:12-alpine AS nodejs
FROM ruby:2.6-alpine3.10 AS ruby
FROM fluke667/alpine:webserver
#FROM node:alpine3.10 as node-builder
#FROM nginx:alpine3.10 as web-builder

COPY --from=java /javarun /opt/jdk/
COPY --from=nodejs /usr/local/bin/node /usr/bin/
COPY --from=nodejs /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=nodejs /opt/ /opt/
#yarn -> /opt/yarn/bin/yarn
#yarnpkg -> /opt/yarn/bin/yarn

RUN apk update && apk add --no-cache \ 
         php7-pecl-mcrypt php7-pecl-ssh2 php7-pecl-igbinary php7-pecl-msgpack php7-pear php7-fpm php7-bcmath php7-ctype php7-curl php7-dom php7-exif \
         php7-fileinfo php7-gmp php7-iconv php7-imagick php7-json php7-mbstring php7-mysqli php7-opcache php7-openssl php7-ftp \
         php7-gd php7-phar php7-posix php7-session php7-simplexml php7-soap php7-sodium php7-sockets php7-tokenizer php7-imap \
         php7-xml php7-xmlreader php7-xmlwriter php7-zip php7-zlib php7-apcu php7-bz2 php7-cli php7-intl php7-ldap php7-mcrypt \
         php7-memcached php7-pcntl php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-redis php7-brotli php7-dev libedit-dev zlib-dev pcre2-dev \
         nginx nginx-mod-http-echo nginx-mod-http-fancyindex nginx-mod-http-geoip nginx-mod-http-geoip2 nginx-mod-http-headers-more \
         nginx-mod-http-image-filter nginx-mod-http-js nginx-mod-stream-js nginx-mod-http-nchan nginx-mod-http-perl nginx-mod-mail \
         nginx-mod-http-redis2 nginx-mod-http-set-misc nginx-mod-http-upload-progress nginx-mod-http-xslt-filter nginx-mod-rtmp \
         nginx-mod-stream nginx-mod-stream-geoip nginx-mod-http-cache-purge nginx-mod-http-shibboleth nginx-mod-http-upstream-fair \
         nginx-mod-http-vod nginx-mod-devel-kit \
         nginx openssl curl ca-certificates ffmpeg libressl libsmbclient libxml2 re2c python3 su-exec tzdata certbot \
         certbot-nginx mariadb mariadb-client mariadb-server-utils mariadb-mytop pwgen bash redis bash-completion nano mysecureshell unit \
         #rakudo zef \
         busybox busybox-extras busybox-initscripts gettext shadow uwsgi uwsgi-python3 lua5.3 lua5.3-dev luarocks5.3 brotli \
         libstdc++ && \
         
    apk update && apk add --no-cache --virtual build-deps \ 
         gd-dev geoip-dev libmaxminddb-dev libxml2-dev libxslt-dev linux-headers openssl-dev paxmark pcre-dev perl-dev pkgconf \
         gcc libc-dev make mercurial alpine-sdk findutils curl gnupg1 autoconf automake build-base gnupg \
         libtool samba-dev tar wget freetype-dev icu-dev libevent-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev \
         libmemcached-dev libzip-dev openldap-dev imagemagick-dev libwebp-dev brotli-dev && \
         
         
         pear config-set php_ini /etc/php7/php.ini && pear channel-update pear.php.net && \
         pecl config-set php_ini /etc/php7/php.ini && pecl channel-update pecl.php.net && \
         pecl install smbclient xdebug && \
         curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
         composer global require hirak/prestissimo && \
         composer global require --optimize-autoloader && \
         apk del build-deps
         
# Expose the ports for nginx
EXPOSE 8080 80 81 443 3306

VOLUME ["/var/www"]

ADD config /config


#COPY entrypoint.sh /
#RUN chmod a+x /config/entrypoint.sh
#ENTRYPOINT ["/config/entrypoint.sh"]
