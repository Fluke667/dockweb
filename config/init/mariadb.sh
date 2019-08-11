#!/bin/sh

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
