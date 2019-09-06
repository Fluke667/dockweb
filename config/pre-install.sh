#!/bin/sh

addgroup -g 1010 -S $NGINX_WWWGRP &
adduser -u 1010 -D -S -h /var/www -s /sbin/nologin -G $NGINX_WWWUSR $NGINX_WWWGRP &
useradd -m -s /bin/bash  -U  dockweb &
addgroup -g 1011 node &
adduser -u 1011 -G node -s /bin/bash -D node &



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
        mkdir -p /etc/mysql/conf.d/
        chown -R ${MARIADB_USR}:${MARIADB_GRP} /etc/mysql
else
        mkdir -p /etc/mysql
	mkdir -p /etc/mysql/conf.d/
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

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (REDIS) *****"
if [ -d "/run/redis" ]; then
         touch /run/redis/redis.sock
         touch /run/redis/redis.pid
	 chown -R redis:redis /run/redis
else
        mkdir -p /run/redis
         touch /run/redis/redis.sock
         touch /run/redis/redis.pid
         chown -R redis:redis /run/redis
fi
if [ -d "/var/log/redis" ]; then
         touch /var/log/redis/redis.log
	 touch /var/log/redis/redis-sentinel.log
else
         mkdir -p /var/log/redis
         touch /var/log/redis/redis.log
         touch /var/log/redis/redis-sentinel.log
fi

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES (YARN) *****"
if [ -f "/usr/bin/yarn" ]; then
yarn
yanpkg
else
ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/bin/yarn
ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/bin/yarnpkg
yarn
yarnpkg
fi




if [ ! -d "/var/log/adminer" ]; then
mkdir -p /var/log/adminer
fi
if [ ! -d "/var/www/${HOST1_DN}/nextcloud" ]; then
mkdir -p /var/www/${HOST1_DN}
mkdir -p /var/www/${HOST1_DN}/nextcloud
fi
if [ ! -d "/var/www/${HOST2_DN}/adminer" ]; then
mkdir -p /var/www/${HOST2_DN}
mkdir -p /var/www/${HOST2_DN}/adminer
fi
if [ ! -d "/var/www/${HOST3_DN}" ]; then
mkdir -p /var/www/${HOST3_DN}
fi
if [ ! -d "/etc/nginx/sites-available" ]; then
mkdir -p /etc/nginx/sites-available
fi
if [ ! -d "/etc/nginx/sites-enabled" ]; then
mkdir -p /etc/nginx/sites-enabled
fi
if [ ! -d "/etc/nginx/config" ]; then
mkdir -p /etc/nginx/config
fi
if [ ! -d "/var/lib/nginx" ]; then
mkdir -p /var/lib/nginx
fi
if [ ! -d "/home/dockweb/python3/apps" ]; then
mkdir -p /home/dockweb/python3/apps
fi
if [ ! -d "/home/dockweb/python3/apps/data" ]; then
mkdir -p /home/dockweb/python3/apps/data
fi
if [ ! -d "/run/uwsgi" ]; then
mkdir -p /run/uwsgi
fi
if [ ! -d "/var/www/_letsencrypt" ]; then
mkdir -p /var/www/_letsencrypt
fi
if [ ! -d "/etc/composer" ]; then
mkdir -p /etc/composer
fi
if [ ! -d "/etc/bash" ]; then
mkdir -p /etc/bash
fi



#addgroup -S php7-fpm 2>/dev/null 
#adduser -S -D -H -h /var/lib/php7/fpm -s /sbin/nologin -G php7-fpm -g php7-fpm php7-fpm 2>/dev/null
#addgroup nginx www-data 2>/dev/null

#chown -R mysql:mysql /var/log/adminer &
chown -R www-data:www-data /var/www/_letsencrypt &



	echo 
	echo 'Pre-Install process done. Ready for init MariaDB.'   
	echo

"$@"
