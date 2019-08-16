#!/bin/sh

mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled


cat >/etc/nginx/sites-enabled/default<<-EOF
server {
        listen 8080 default_server;
        listen [::]:8080 default_server;
        root /var/www;
        index index.php index.html index.htm index.py;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }
}
# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}
EOF



cat >/etc/nginx/sites-enabled/${HOST_DOMAIN1}.conf<<EOF
server {
        listen 8080;
        listen [::]:8080;
        server_name ${HOST_DOMAIN1};
        root /var/www/${HOST_DOMAIN1};
        index index.php index.html index.htm index.py;
        autoindex on;
        charset utf-8;
        server_name ${HOST_DOMAIN1}; www.${HOST_DOMAIN1};

        location / {
                try_files $uri $uri/ =404;
        }
  }
EOF
"$@"
