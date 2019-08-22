#!/bin/sh

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (MARIADB) *****"
if [ -d "/run/mysqld" ]; then
        touch /run/mysqld/mysqld.pid
	touch /run/mysqld/mysqld.sock
	chown -R ${MARIADB_USR}:${MARIADB_GRP} /run/mysqld
else
	mkdir -p /run/mysqld
	touch /run/mysqld/mysqld.pid
	touch /run/mysqld/mysqld.sock
	chown -R ${MARIADB_USR}:${MARIADB_GRP} /run/mysqld
fi

if [ -d "/var/log/mariadb" ]; then
        chown -R ${MARIADB_USR}:${MARIADB_GRP} /var/log/mariadb
else
        mkdir -p /var/log/mariadb
        chown -R ${MARIADB_USR}:${MARIADB_GRP} /var/log/mariadb
fi

if [ -d "/etc/mysql" ]; then
        chown -R ${MARIADB_USR}:${MARIADB_GRP} /etc/mysql
else
        mkdir -p /etc/mysql
        chown -R ${MARIADB_USR}:${MARIADB_GRP} /etc/mysql
fi

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (NGINX) *****"
if [ -d "/var/log/nginx" ]; then
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/nginx
else
        mkdir -p /var/log/nginx
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/nginx
fi

if [ -d "/run/nginx" ]; then
        touch /run/nginx/nginx.pid
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/nginx
else
        mkdir -p /run/nginx
	touch /run/nginx/nginx.pid
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/nginx
fi

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (PHP-FPM 7.2) *****"
if [ -d "/var/log/php7" ]; then
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/php7
else
        mkdir -p /var/log/php7
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/php7
fi

if [ -d "/run/php7" ]; then
        touch /run/php7/php7.2-fpm.sock
	touch /run/php7/php-fpm7.pid
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/php7
else
        mkdir -p /run/php7
	touch /run/php7/php7.2-fpm.sock
	touch /run/php7/php-fpm7.pid
        chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/php7
fi

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (PHP-FPM 7.2) *****"




if [ ! -d "/var/log/adminer" ]; then
mkdir -p /var/log/adminer
fi
if [ ! -d "/var/www/fluke667_me/adminer" ]; then
mkdir -p /var/www/fluke667_me/adminer
fi
if [ ! -d "/var/www/fluke667_host/nextcloud" ]; then
mkdir -p /var/www/fluke667_host/nextcloud
fi
if [ ! -d "/etc/nginx/sites-available" ]; then
mkdir -p /etc/nginx/sites-available
fi
if [ ! -d "/etc/nginx/sites-enabled" ]; then
mkdir -p /etc/nginx/sites-enabled
fi
if [ ! -d "/etc/nginx/snippets" ]; then
mkdir -p /etc/nginx/snippets
fi
if [ ! -d "/var/lib/nginx" ]; then
mkdir -p /var/lib/nginx
fi


chown -R mysql:mysql /var/log/adminer &

#addgroup -S php7-fpm 2>/dev/null 
#adduser -S -D -H -h /var/lib/php7/fpm -s /sbin/nologin -G php7-fpm -g php7-fpm php7-fpm 2>/dev/null
#addgroup nginx www-data 2>/dev/null


wget -P /var/www/$HOST2_DN/adminer https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php


	echo 
	echo 'Pre-Install process done. Ready for init MariaDB.'   
	echo

"$@"
