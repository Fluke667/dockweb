#!/bin/sh


cat >/usr/bin/occ <<-EOF
su-exec nginx php -f /var/www/nextcloud/occ 
EOF


#cat >/var/www/nextcloud/config/config.php <<-EOF



"$@"
