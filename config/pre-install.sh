#!/bin/sh

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES *****"
if [ ! -d "/var/log/mariadb" ]; then
mkdir -p /var/log/mariadb
fi
if [ ! -d "/var/log/adminer" ]; then
mkdir -p /var/log/adminer
fi
if [ ! -d "/var/log/nginx" ]; then
mkdir -p /var/log/nginx
fi
if [ ! -d "/var/log/php7" ]; then
mkdir -p /var/log/php7
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
if [ ! -d "/run/nginx" ]; then
mkdir -p /run/nginx
fi
if [ ! -d "/run/php" ]; then
mkdir -p /run/php
fi
if [ ! -d "/var/lib/nginx" ]; then
mkdir -p /var/lib/nginx
fi



chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/nginx &
chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /var/log/php7 &
chown -R mysql:mysql /var/log/adminer &
chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/nginx &
chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} /run/php &
chown -R ${MARIADB_USR}:${MARIADB_GRP} /var/log/mariadb &
chown -R ${MARIADB_USR}:${MARIADB_GRP} /run/mysqld &

#addgroup -S php7-fpm 2>/dev/null 
#adduser -S -D -H -h /var/lib/php7/fpm -s /sbin/nologin -G php7-fpm -g php7-fpm php7-fpm 2>/dev/null
#addgroup nginx www-data 2>/dev/null


wget -P /var/www/$HOST2_DN/adminer https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php


	echo 
	echo 'Pre-Install process done. Ready for init MariaDB.'   
	echo

"$@"
