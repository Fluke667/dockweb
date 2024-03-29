#!/bin/sh

pip3 install --upgrade pip gixy flask &


cat >/etc/uwsgi/uwsgi.ini <<-EOF
[uwsgi]
socket = /run/uwsgi/uwsgi.sock
chmod-socket = 775
chdir = /home/dockweb/python3/apps/data
master = true
binary-path = /usr/sbin/uwsgi
virtualenv = /home/dockweb/python3
module = flaskapp:app
uid = www-data
gid = www-data
processes = 2
threads = 4
plugins = python3,logfile
logger = file:/var/log/uwsgi.log
EOF


	echo   
	echo -e "${INFO} Python3 init process done. Ready for init Redis." 
	echo


"$@"
