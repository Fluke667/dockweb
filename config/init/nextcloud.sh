#!/bin/sh


cat >/usr/bin/occ <<-EOF
su-exec nginx php -f /var/www/nextcloud/occ 
EOF

	echo 
	echo 'Nextcloud init process done. Ready for .....'     
	echo


#cat >/var/www/nextcloud/config/config.php <<-EOF



"$@"
