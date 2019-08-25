#!/bin/sh

cd /config && chmod u+x * -R &
sh /config/pre-install.sh &
sh /config/init/mariadb.sh &
sh /config/init/php7.sh &
sh /config/init/domains.sh &
sh /config/init/nginx.sh &
sh /config/init/nextcloud.sh &
#sh /config/init/openssl.sh &
#cp /config/etc/php7/php.ini /etc/php7/php.ini &




#mysqld --user=mysql &
#php-fpm7 &
#nginx &
#certbot certonly --verbose --noninteractive --quiet --nginx --agree-tos --email="${HOST_EMAIL}" -d "${HOST_DOMAIN1}, www.${HOST_DOMAIN1}"
#uwsgi --http :8000 --wsgi-file test.py


"$@"
