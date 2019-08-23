FROM fluke667/alpine-java AS javabuilder
FROM fluke667/alpine-golang:latest AS gobuilder
FROM fluke667/alpine
#FROM node:alpine3.10 as node-builder
#FROM nginx:alpine3.10 as web-builder

COPY --from=javabuilder /javarun /opt/jdk/

RUN apk update && apk add --no-cache \ 
         php7-pecl-mcrypt php7-pecl-ssh2 php7-pecl-igbinary php7-pear php7-fpm php7-bcmath php7-ctype php7-curl php7-dom php7-exif \
         php7-fileinfo php7-gmp php7-iconv php7-imagick php7-json php7-mbstring php7-mysqli php7-opcache php7-openssl php7-ftp \
         php7-gd php7-phar php7-posix php7-session php7-simplexml php7-soap php7-sodium php7-sockets php7-tokenizer php7-imap \
         php7-xml php7-xmlreader php7-xmlwriter php7-zip php7-zlib php7-apcu php7-bz2 php7-cli php7-intl php7-ldap php7-mcrypt \
         php7-memcached php7-pcntl php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-redis \
         nginx nginx-mod-http-echo nginx-mod-http-fancyindex nginx-mod-http-geoip nginx-mod-http-geoip2 nginx-mod-http-headers-more \
         nginx-mod-http-image-filter nginx-mod-http-js nginx-mod-stream-js nginx-mod-http-nchan nginx-mod-http-perl nginx-mod-mail \
         nginx-mod-http-redis2 nginx-mod-http-set-misc nginx-mod-http-upload-progress nginx-mod-http-xslt-filter nginx-mod-rtmp \
         nginx-mod-stream nginx-mod-stream-geoip nginx-mod-http-cache-purge nginx-mod-http-shibboleth nginx-mod-http-upstream-fair \
         nginx-mod-http-vod nginx-mod-devel-kit \
         nginx openssl curl ca-certificates ffmpeg libressl libsmbclient libxml2 re2c python3 su-exec tzdata composer certbot \
         certbot-nginx mariadb mariadb-client mariadb-server-utils mariadb-mytop pwgen bash nano \
         #rakudo zef \
         busybox busybox-extras busybox-initscripts gettext shadow && \
         
    apk update && apk add --no-cache --virtual build-deps \ 
         gd-dev geoip-dev libmaxminddb-dev libxml2-dev libxslt-dev linux-headers openssl-dev paxmark pcre-dev perl-dev pkgconf \
         zlib-dev gcc libc-dev make libedit-dev mercurial alpine-sdk findutils curl gnupg1 autoconf automake build-base gnupg \
         libtool php7-dev samba-dev tar wget freetype-dev icu-dev libevent-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev \
         libmemcached-dev libzip-dev openldap-dev imagemagick-dev libwebp-dev && \
         
         pip3 install --upgrade pip && \
         pear config-set php_ini /etc/php7/php.ini && \
         #pear install channel://pear.php.net/HTML_Template_IT-1.3.1 \
         #pear install channel://pear.php.net/PEAR_Frontend_Web-0.7.5 && \
         pecl config-set php_ini /etc/php7/php.ini && \
         pecl install smbclient && \
         apk del build-deps
         
# Expose the ports for nginx
EXPOSE 8080 80 81 443 3306

VOLUME ["/var/www"]

ADD config /config


#COPY entrypoint.sh /
#RUN chmod a+x /config/entrypoint.sh
#ENTRYPOINT ["/config/entrypoint.sh"]
