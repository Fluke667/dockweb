#!/bin/sh

cat >/etc/nginx/config/letsencrypt.conf<<-EOF
# ACME-challenge
location ^~ /.well-known/acme-challenge/ {
	root /var/www/_letsencrypt;
}
EOF

cat >/etc/nginx/modules/http_geoip2.conf<<-EOF
load_module "modules/ngx_http_geoip2_module.so";
EOF

cat >/etc/nginx/modules/stream_geoip2.conf<<-EOF
load_module "modules/ngx_stream_geoip2_module.so";
EOF

cat >/etc/nginx/config/security.conf<<-EOF
# security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

# . files
location ~ /\.(?!well-known) {
	deny all;
}
EOF


cat >/etc/nginx/config/php_fastcgi.conf<<-EOF
# 404
try_files \$fastcgi_script_name =404;

# default fastcgi_params
include fastcgi_params;

# fastcgi settings
fastcgi_pass			unix:/run/php7/php7.2-fpm.sock;
fastcgi_index			index.php;
fastcgi_buffers			8 16k;
fastcgi_buffer_size		32k;

# fastcgi params
fastcgi_param DOCUMENT_ROOT		\$realpath_root;
fastcgi_param SCRIPT_FILENAME	\$realpath_root\$fastcgi_script_name;
#fastcgi_param PHP_ADMIN_VALUE	"open_basedir=$base/:/usr/lib/php/:/tmp/";
EOF


cat >/etc/nginx/config/extras.conf<<-EOF
#dir listing
autoindex on;

# favicon.ico
location = /favicon.ico {
	log_not_found off;
	access_log off;
}

# robots.txt
location = /robots.txt {
	log_not_found off;
	access_log off;
}

# assets, media
location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
	expires 7d;
	access_log off;
}

# svg, fonts
location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
	add_header Access-Control-Allow-Origin "*";
	expires 7d;
	access_log off;
}

# gzip
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

# brotli
brotli on;
brotli_comp_level 6;
brotli_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;
EOF

cat >/etc/nginx/nginx.conf<<-EOF
user www-data;
pid /run/nginx/nginx.pid;
worker_processes 4;
worker_rlimit_nofile 65535;

events {
	multi_accept on;
	worker_connections 65535;
}

http {
	charset utf-8;
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	log_not_found off;
	types_hash_max_size 2048;
	client_max_body_size 2000M;

	# MIME
	include mime.types;
	default_type application/octet-stream;

	# logging
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log warn;

	# limits
	limit_req_log_level warn;
	limit_req_zone $binary_remote_addr zone=login:10m rate=10r/m;

	# SSL
	ssl_session_timeout 1d;
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off;

	# Diffie-Hellman parameter for DHE ciphersuites
	ssl_dhparam /etc/nginx/dhparam.pem;

	# Mozilla Intermediate configuration
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

	# OCSP Stapling
	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 1.1.1.1 1.0.0.1 valid=60s;
	resolver_timeout 2s;

	# load configs
	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
EOF



      
      
        

	echo 
	echo -e "${INFO} Nginx init process done. Ready for init Nextcloud." 
	echo


"$@"
