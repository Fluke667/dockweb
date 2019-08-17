#!/bin/sh

cd /config && chmod u+x * -R &
#sh /config/pre-install.sh &
sh /config/init/mariadb.sh &
sh /config/init/php7.sh &
sh /config/init/domains.sh &
sh /config/init/nginx.sh &
#sh /config/init/adminer.sh &
#sh /config/init/openssl.sh &
#cp /config/etc/php7/php.ini /etc/php7/php.ini &




#mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_docker -e "INSERT INTO users(username, name) VALUES ('admin', 'Admin')"
mysqld --user=mysql &
php-fpm7 &
nginx &
certbot certonly --verbose --noninteractive --quiet --nginx --agree-tos --email="${HOST_EMAIL}" -d "${HOST_DOMAIN1}, www.${HOST_DOMAIN1}"



"$@"
