#!/bin/sh

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

  
  # Create root user, set root password, drop useless table
  # Delete root user except for
  execute <<SQL
    -- What's done in this file shouldn't be replicated
    --  or products like mysql-fabric won't work
    SET @@SESSION.SQL_LOG_BIN=0;
    DELETE FROM mysql.user WHERE user NOT IN ('mysql.sys', 'mysqlxsys', 'root') OR host NOT IN ('localhost') ;
    SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MARIADB_ROOT_PASS}') ;
    GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
    DROP DATABASE IF EXISTS test ;
    FLUSH PRIVILEGES ;
SQL




rm /etc/my.cnf

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

"$@"
