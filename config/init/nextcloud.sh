#!/bin/sh

cd /tmp
wget -q  ${NEXTCLOUD_DL}.tar.bz2 &
tar -xjf latest.tar.bz2 --strip 1 -C ${NEXTCLOUD_PATH} &
mkdir -p $NEXTCLOUD_PATH/data $NEXTCLOUD_PATH/assets $NEXTCLOUD_PATH/updater &
find ${NEXTCLOUD_PATH} -type f -print0 -maxdepth 1 | xargs -0 chmod 0640 &
find ${NEXTCLOUD_PATH} -type d -print0 -maxdepth 1 | xargs -0 chmod 0750 &
chown ${ROOTUSR}:${NGINX_WWWUSER} ${NEXTCLOUD_PATH}/. &
chown ${NGINX_WWWUSR}:${NGINX_WWWGRP} ${NEXTCLOUD_PATH}/data &
find ${NEXTCLOUD_PATH} ! -path */nextcloud/data/* -print0 | xargs -0 chown -R ${NGINX_WWWUSR}:${NGINX_WWWGRP} &
chmod +x ${NEXTCLOUD_PATH}/occ

cat >/usr/bin/occ <<-EOF
su-exec nginx php -f ${NEXTCLOUD_PATH}/occ 
EOF



cat >/var/www/nextcloud/config/autoconfig.php <<-EOF
<?php
$AUTOCONFIG = array(
  "dbtype"        => "$NEXTCLOUD_DB_TYPE",
  "dbname"        => "$NEXTCLOUD_DB_DATABASE",
  "dbuser"        => "$NEXTCLOUD_DB_USER",
  "dbpass"        => "$NEXTCLOUD_DB_PASS",
  "dbhost"        => "$NEXTCLOUD_DB_HOST",
  "dbtableprefix" => "$NEXTCLOUD_DB_PREFIX",
  "adminlogin"    => "$NEXTCLOUD_USER",
  "adminpass"     => "$NEXTCLOUD_PASS",
  "directory"     => "$NEXTCLOUD_DATA",
);
EOF




      
      
        

	echo 
	echo -e "${INFO} Nextcloud init process done. Ready for init Python3."  
	echo


"$@"
