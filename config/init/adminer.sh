#!/bin/sh

mkdir /var/www/adminer /var/log/adminer /etc/nginx/modules-available /etc/nginx/modules-enabled &
wget -P/var/www/adminer https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php &
chown -R nginx /var/www/adminer


cat >/etc/nginx/sites-available/adminer.conf<<-EOF
server {

    # Listen on port 80
    listen 81;

    # Server name being used (exact name, wildcards or regular expression)
    # server_name adminer.my;

    root /var/www/adminer;

    # Logging
    error_log /var/log/adminer/adminer.access_log;
    access_log /var/log/adminer/adminer.error_log;


   location / {
           index  index.php;
       }

       ## Images and static content is treated different
       location ~* ^.+.(jpg|jpeg|gif|css|png|js|ico|xml)$ {
           access_log        off;
           expires           360d;
       }

       location ~ /\.ht {
           deny  all;
       }

       location ~ /(libraries|setup/frames|setup/libs) {
           deny all;
           return 404;
}

    # Pass the PHP scripts to FastCGI server
    location ~ \.php$ {

        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/adminer/adminer$fastcgi_script_name;
        fastcgi_param  HTTPS off;
    }
}
EOF


"$@"
