#!/bin/sh


cd /config && chmod u+x * -R &
sh /config/init/mariadb.sh &
sh /config/init/php7.sh &
sh /config/init/nginx.sh &
sh /config/init/domain1.sh &
sh /config/init/adminer.sh
#cp /config/etc/php7/php.ini /etc/php7/php.ini &


 
 if [ -z "${HOST_EMAIL}" ]; then
    DockLog "ERROR: administrator email is mandatory"
  elif [ -z "${HOST_DOMAIN1}" ]; then
    DockLog "ERROR: at least one domain must be specified"
  else
    exec certbot certonly --verbose --noninteractive --quiet --standalone --agree-tos --email="${HOST_EMAIL}" -d "${HOST_DOMAIN1}"
  fi
elif [ "${1}" == 'certbot-renew' ]; then
   exec certbot renew
else




#mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_docker -e "INSERT INTO users(username, name) VALUES ('admin', 'Admin')"
mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 &
php-fpm7 -c /etc/php7/php.ini -y /etc/php7/php7-fpm.conf &
nginx



  "$@"
