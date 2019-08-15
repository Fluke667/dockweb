#!/bin/sh

mkdir /var/www/adminer &
cd /tmp &
wget https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php
cp adminer-4.7.2.php /var/www/adminer
chown -R nginx /var/www/adminer

"$@"
