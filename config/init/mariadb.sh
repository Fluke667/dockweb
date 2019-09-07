#!/bin/sh

sed -i 's/^.*auth_pam_tool_dir.*$/#auth_pam_tool_dir not exists/' /usr/bin/mysql_install_db &

cat >/etc/mysql/my.cnf <<-EOF

# This group is read by the server
[mysqld]
datadir=/var/lib/mysql
basedir=/usr
plugin_dir=/usr/lib/mariadb/plugin
pid_file=/run/mysqld/mysqld.pid
socket=/run/mysqld/mysqld.sock
symbolic-links=0
skip-external-locking
key_buffer_size=32K
max_allowed_packet=4M
table_open_cache=8
sort_buffer_size=128K
read_buffer_size=512K
read_rnd_buffer_size=512K
net_buffer_length=4K
thread_stack=480K
max_connections=100
max_user_connections=50
wait_timeout=50
interactive_timeout=50
long_query_time=5
performance_schema=on
transaction_isolation=READ-COMMITTED
binlog_format=ROW
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
innodb_file_per_table=1
innodb_file_format=barracuda
innodb_file_per_table=1
innodb_large_prefix=on
innodb_stats_on_metadata=0
innodb_buffer_pool_size=768M
innodb_io_capacity=4000
#require_secure_transport = on
#ssl-cert = /etc/letsencrypt/live/$HOST1_DN/fullchain.pem
#ssl-key = /etc/letsencrypt/live/$HOST1_DN/privkey.pem
#ssl-cipher = ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
#tls_version = TLSv1.2,TLSv1.3


[server]
skip-name-resolve
query_cache_type=1
query_cache_limit=2M
query_cache_min_res_unit=2k
query_cache_size=64M
tmp_table_size=64M
max_heap_table_size=64M
slow-query-log=1
slow-query-log-file=/var/log/mariadb/slow.log
long_query_time=1
innodb_buffer_pool_instances=1
innodb_flush_log_at_trx_commit=2
innodb_log_buffer_size=32M
innodb_max_dirty_pages_pct=90


[client]
default-character-set = utf8mb4

# This group is read both both by the client and the server
# use it for options that affect everything
[client-server]
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/
!includedir /etc/my.cnf.d
EOF




echo >/etc/my.cnf.d/mariadb-server.cnf<<EOF
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]
skip-networking

# Galera-related settings
[galera]
# Mandatory settings
#wsrep_on=ON
#wsrep_provider=
#wsrep_cluster_address=
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#
# Allow server to accept connections on all interfaces.
#
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]
log_warnings=4
log_error=/var/log/mariadb/error.log

# This group is only read by MariaDB-10.3 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.3]
EOF

if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R ${MARIADB_USR}:${MARIADB_GRP} /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R ${MARIADB_USR}:${MARIADB_GRP} /var/lib/mysql

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
			echo "[i] with character set: 'utf8mb4' and collation: 'utf8mb4_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" >> /etc/mysql/tfile
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
			echo "[i] with character set: 'utf8mb4' and collation: 'utf8mb4_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$NEXTCLOUD_DB_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" >> /etc/mysql/tfile
		fi

	 if [ "$NEXTCLOUD_DB_USER" != "" ]; then
		echo "[i] Creating user: $NEXTCLOUD_DB_USER with password $NEXTCLOUD_DB_PASS"
		echo "GRANT ALL ON \`$NEXTCLOUD_DB_DATABASE\`.* to '$NEXTCLOUD_DB_USER'@'%' IDENTIFIED BY '$NEXTCLOUD_DB_PASS';" >> /etc/mysql/tfile
	    fi
	fi
	##########
	/usr/bin/mysql_install_db --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < /etc/mysql/tfile
	rm -f /etc/mysql/tfile



        echo
        echo -e "${INFO} MariaDB init process done. Ready for init PHP-FPM 7.2"
        echo

fi

"$@"
