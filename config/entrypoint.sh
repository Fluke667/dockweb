#!/bin/sh

cd /config && chmod u+x * -R &
sh /config/pre-install.sh &
sh /config/init/mariadb.sh &
sh /config/init/php7.sh &
sh /config/init/domain1.sh &
sh /config/init/domain2.sh &
sh /config/init/domain3.sh &
sh /config/init/nginx.sh &
sh /config/init/nextcloud.sh &
sh /config/init/python3.sh &
#sh /config/init/openssl.sh &
sh /config/init/letsencrypt.sh &
sh /config/init/manage-tools.sh &
sh /config/init/bash.sh
#cp /config/etc/php7/php.ini /etc/php7/php.ini &




#mysqld --user=mysql &
#php-fpm7 &
#nginx &
#uwsgi --http :8000 --wsgi-file test.py


"$@"
