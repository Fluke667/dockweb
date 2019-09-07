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


if [ ! -f "/etc/letsencrypt/live/$HOST2_DN/fullchain.pem" ]
        then
echo " ---> Comment out SSL related directives in configuration"
   sed -i -r 's/(listen .*443)/\1;#/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g' /etc/nginx/sites-available/$HOST2_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload &
echo " ---> Obtain Certificate"
   certbot certonly --verbose --noninteractive --quiet --agree-tos --nginx --force-renewal --webroot /var/www/_letsencrypt -d "${HOST2_DN}, www.${HOST2_DN}" --email="${HOST_EMAIL}" &
echo " ---> Uncomment SSL related directives in configuration"
   sed -i -r 's/#?;#//g' /etc/nginx/sites-available/$HOST2_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload
else
  echo "ENTRYPOINT: /etc/letsencrypt/live/$HOST2_DN/fullchain.pem already exists"
        fi
        
        
        
if [ ! -f "/etc/letsencrypt/live/$HOST3_DN/fullchain.pem" ]
        then
echo " ---> Comment out SSL related directives in configuration"
   sed -i -r 's/(listen .*443)/\1;#/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g' /etc/nginx/sites-available/$HOST3_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload &
echo " ---> Obtain Certificate"
   certbot certonly --verbose --noninteractive --quiet --agree-tos --nginx --force-renewal --webroot /var/www/_letsencrypt -d "${HOST3_DN}, www.${HOST3_DN}" --email="${HOST_EMAIL}" &
echo " ---> Uncomment SSL related directives in configuration"
   sed -i -r 's/#?;#//g' /etc/nginx/sites-available/$HOST3_DN.conf &
echo " ---> Reload Nginx"
   nginx -t && nginx -s reload
else
  echo "ENTRYPOINT: /etc/letsencrypt/live/$HOST3_DN/fullchain.pem already exists"
        fi
        
        
        
	echo   
        echo -e "${INFO} Letsencrypt init process done. Ready for init Manage Tools."
        echo

        
"$@"
