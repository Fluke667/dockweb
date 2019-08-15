#!/bin/sh

cat >/etc/my.cnf <<-EOF
# This group is read both both by the client and the server
# use it for options that affect everything
[client-server]

# This group is read by the server
[mysqld]
symbolic-links=0
skip-external-locking
key_buffer_size = 32K
max_allowed_packet = 4M
table_open_cache = 8
sort_buffer_size = 128K
read_buffer_size = 512K
read_rnd_buffer_size = 512K
net_buffer_length = 4K
thread_stack = 480K
innodb_file_per_table
max_connections=100
max_user_connections=50
wait_timeout=50
interactive_timeout=50
long_query_time=5

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# include all files from the config directory
!includedir /etc/my.cnf.d
EOF


if [ -d "/run/mysqld" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi


if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	if [ "$MARIADB_ROOT_PASS" = "" ]; then
		MARIADB_ROOT_PASS=`pwgen 16 1`
		echo "[i] MySQL root Password: $MARIADB_ROOT_PASS"
	fi


    cat << EOF > /etc/mysql/tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MARIADB_ROOT_PASS' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MARIADB_ROOT_PASS' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MARIADB_ROOT_PASS}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

	if [ "$DB_DATABASE" != "" ]; then
	    echo "[i] Creating database: $DB_DATABASE"
		if [ "$MARIADB_CHARSET" != "" ] && [ "$MARIADB_COLLATION" != "" ]; then
			echo "[i] with character set [$MARIADB_CHARSET] and collation [$MARIADB_COLLATION]"
			echo "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\` CHARACTER SET $MARIADB_CHARSET COLLATE $MARIADB_COLLATION;" >> /etc/mysql/tfile
		else
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /etc/mysql/tfile
		fi

	 if [ "$DB_USER" != "" ]; then
		echo "[i] Creating user: $DB_USER with password $DB_PASS"
		echo "GRANT ALL ON \`$DB_DATABASE\`.* to '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';" >> /etc/mysql/tfile
	    fi
	fi
	########
		if [ "$NEXTCLOUD_DB_DATABASE" != "" ]; then
	    echo "[i] Creating database: $NEXTCLOUD_DB_DATABASE"
		if [ "$MARIADB_CHARSET" != "" ] && [ "$MARIADB_COLLATION" != "" ]; then
			echo "[i] with character set [$MARIADB_CHARSET] and collation [$MARIADB_COLLATION]"
			echo "CREATE DATABASE IF NOT EXISTS \`$NEXTCLOUD_DB_DATABASE\` CHARACTER SET $MARIADB_CHARSET COLLATE $MARIADB_COLLATION;" >> /etc/mysql/tfile
		else
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$NEXTCLOUD_DB_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /etc/mysql/tfile
		fi

	 if [ "$NEXTCLOUD_DB_USER" != "" ]; then
		echo "[i] Creating user: $NEXTCLOUD_DB_USER with password $NEXTCLOUD_DB_PASS"
		echo "GRANT ALL ON \`$NEXTCLOUD_DB_DATABASE\`.* to 'NEXTCLOUD_DB_USER'@'%' IDENTIFIED BY '$NEXTCLOUD_DB_PASS';" >> /etc/mysql/tfile
	    fi
	fi
	##########
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < /etc/mysql/tfile
	rm -f /etc/mysql/tfile



	echo
	echo 'MySQL init process done. Ready for start up.'
	echo

	echo "exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
fi


#exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 
"$@"
