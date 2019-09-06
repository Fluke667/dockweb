#!/bin/sh
wget -P /var/www/$HOST1_DN ${NEXTCLOUD_DL}.tar.bz2 && cd /var/www/$HOST1_DN && tar -xjf latest.tar.bz2 &
mkdir -p $NEXTCLOUD_PATH/data $NEXTCLOUD_PATH/assets $NEXTCLOUD_PATH/updater &
find ${NEXTCLOUD_PATH} -type f -print0 -maxdepth 1 | xargs -0 chmod 0640 &
find ${NEXTCLOUD_PATH} -type d -print0 -maxdepth 1 | xargs -0 chmod 0750 &
chown ${ROOTUSR}:${NGINX_WWWUSER} ${NEXTCLOUD_PATH}/. &
chown ${NGINX_WWWUSR}:${NGINX_WWWGRP} ${NEXTCLOUD_PATH}/data &
find ${NEXTCLOUD_PATH} ! -path */nextcloud/data/* -print0 | xargs -0 chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP}
chmod +x ${NEXTCLOUD_PATH}/occ

cat >/usr/bin/occ <<-EOF
su-exec nginx php -f ${NEXTCLOUD_PATH}/occ 
EOF



#cat >/var/www/nextcloud/config/config.php <<-EOF
chmod +x /usr/bin/occ




      
      
        

	echo 
	echo 'Nextcloud init process done. Ready for init Python3.'   
	echo


"$@"
