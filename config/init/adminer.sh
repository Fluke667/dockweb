#!/bin/sh

mkdir /var/www/adminer &
cd /var/www/adminer &
wget https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php
chown -R nginx /var/www/adminer

"$@"
