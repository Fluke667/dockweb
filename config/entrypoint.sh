#!/bin/sh


cd /config && chmod u+x * -R &
sh /config/init/mariadb.sh &
sh /config/init/nginx.sh &
sh /config/init/php7.sh &
cp /config/etc/php7/php.ini /etc/php7/php.ini &


 
 if [ -z "${DOCKMAIL}" ]; then
    DockLog "ERROR: administrator email is mandatory"
  elif [ -z "${DOCKDOMAINS}" ]; then
    DockLog "ERROR: at least one domain must be specified"
  else
    exec certbot certonly --verbose --noninteractive --quiet --standalone --agree-tos --email="${CERTBOT_EMAIL}" -d "${CERTBOT_DOMAINS}" 
  fi
elif [ "${1}" == 'certbot-renew' ]; then
   exec certbot renew
else



#mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_docker -e "INSERT INTO users(username, name) VALUES ('admin', 'Admin')"
/usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 


  "$@"
