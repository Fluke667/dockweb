#!/bin/sh

wget -P /var/www/$HOST2_DN/adminer https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php
wget -P /usr/bin https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl
wget -P /config/db https://github.com/FromDual/mariadb-sys/archive/master.zip


chmod +x /usr/bin/mysqltuner.pl

cd /config/db && unzip -x master.zip
cd /config/db/mariadb-sys-master && mysql -u root -p"$MYSQL_ROOT_PASSWORD" < ./sys_10.sql


        echo    
	echo -e "${INFO} Manage Tools init process done. Ready for init Bash."  
	echo
  
  "$@"
