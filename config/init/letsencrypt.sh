#!/bin/sh

if [ ! -f "/etc/letsencrypt/live/$HOST1_DN/fullchain.pem" ]
        then
echo " ---> Comment out SSL related directives in configuration"
   sed -i -r 's/(listen .*443)/\1;#/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g' /etc/nginx/sites-available/$HOST1_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload &
echo " ---> Obtain Certificate"
   certbot certonly --verbose --noninteractive --quiet --agree-tos --nginx --force-renewal --webroot /var/www/_letsencrypt -d "${HOST1_DN}, www.${HOST1_DN}" --email="${HOST_EMAIL}" &
echo " ---> Uncomment SSL related directives in configuration"
   sed -i -r 's/#?;#//g' /etc/nginx/sites-available/$HOST1_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload
else
  echo "ENTRYPOINT: /etc/letsencrypt/live/$HOST1_DN/fullchain.pem already exists"
        fi
