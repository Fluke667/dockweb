#!/bin/sh

if [ ! -f "/etc/letsencrypt/live/$HOST1_DN/fullchain.pem" ]
        then
echo " ---> Comment out SSL related directives in configuration"
   sed -i -r 's/(listen .*443)/\1;#/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g' /etc/nginx/sites-available/$HOST1_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload &
echo " ---> Obtain Certificate"
   certbot certonly --webroot -d $HOST1_DN -d www.$HOST1_DN --email info@$HOST1_DN -w /var/www/_letsencrypt -n --agree-tos --force-renewal &
echo " ---> Uncomment SSL related directives in configuration"
   sed -i -r 's/#?;#//g' /etc/nginx/sites-available/$HOST1_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload
else
  echo "ENTRYPOINT: /etc/letsencrypt/live/$HOST1_DN/fullchain.pem already exists"
        fi
