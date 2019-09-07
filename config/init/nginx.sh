#!/bin/sh


cat >/etc/nginx/config/fastcgi-php.conf<<-EOF
# regex to split $uri to $fastcgi_script_name and $fastcgi_path
fastcgi_split_path_info ^(.+\.php)(/.+)$;

# Check that the PHP script exists before passing it
try_files $fastcgi_script_name =404;

# Bypass the fact that try_files resets $fastcgi_path_info
# see: http://trac.nginx.org/nginx/ticket/321
set $path_info $fastcgi_path_info;
fastcgi_param PATH_INFO $path_info;

# default fastcgi_params
include fastcgi_params;

# fastcgi settings
fastcgi_index			index.php;
fastcgi_buffers                 64 4k;
fastcgi_pass                    unix:/run/php7/php7.2-fpm.sock;
fastcgi_buffer_size		32k;


EOF

cat >/etc/nginx/modules/http_geoip2.conf<<-EOF
load_module "modules/ngx_http_geoip2_module.so";
EOF

cat >/etc/nginx/modules/stream_geoip2.conf<<-EOF
load_module "modules/ngx_stream_geoip2_module.so";
EOF


cat >/etc/nginx/nginx.conf<<-EOF
user nginx;
worker_processes 4;
pid /run/nginx/nginx.pid;
include /etc/nginx/modules/*.conf;

events {
        worker_connections 1024;
        multi_accept off;
}

http {

        ##
        # Basic Settings
        #
        # Optimized with: https://hostadvice.com/how-to/how-to-tune-and-optimize-performance-of-nginx-web-server/
        ##
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;
        client_body_buffer_size 10K;
        client_header_buffer_size 1k;
        client_max_body_size 512M;
        fastcgi_buffers 64 4K;
        large_client_header_buffers 4 4k;
        client_body_timeout 12;
        client_header_timeout 12;
        send_timeout 10;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        # default_type application/octet-stream;
        default_type        text/html;

        ##
        # SSL Settings
        ##
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;
        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log debug;

        ##
        # Gzip Settings
        ##
        gzip on;
        gzip_vary on;
        gzip_comp_level 4;
        gzip_min_length 256;
        gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
        gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
    
        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
EOF

cat >/etc/nginx/config/python_uwsgi.conf<<-EOF
# default uwsgi_params
include uwsgi_params;

# uwsgi settings
uwsgi_pass				unix:/run/uwsgi/uwsgi.sock;
uwsgi_param Host			$host;
uwsgi_param X-Real-IP			$remote_addr;
uwsgi_param X-Forwarded-For		$proxy_add_x_forwarded_for;
uwsgi_param X-Forwarded-Proto	        $http_x_forwarded_proto;
EOF


cat >/etc/nginx/config/letsencrypt.conf<<-EOF
# ACME-challenge
location ^~ /.well-known/acme-challenge/ {
	root /var/www/_letsencrypt;
}
EOF

cat >/etc/nginx/config/extra.conf<<-EOF
# favicon.ico
location = /favicon.ico {
	log_not_found off;
	access_log off;
}

# robots.txt
location = /robots.txt {
        allow all;
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

    # Enable gzip but do not remove ETag headers
    gzip on; 
    gzip_vary on;  
    gzip_comp_level 4; 
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

   # Enable brotli
   brotli on;
   brotli_comp_level 6;
   brotli_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

EOF

cat >/etc/nginx/config/security.conf<<-EOF

    # HSTS (ngx_http_headers_module is required) (63072000 seconds)
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header Referrer-Policy no-referrer;
    
    # Remove X-Powered-By, which is an information leak
    fastcgi_hide_header X-Powered-By;
    
    # Test Config
    #add_header X-Frame-Options "SAMEORIGIN" always;
    #add_header Referrer-Policy "no-referrer-when-downgrade" always;
    #add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    #add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    
    # . files
location ~ /\.(?!well-known) {
	deny all;
}
EOF

	echo 
	echo -e "${INFO} Nginx init process done. Ready for init Nextcloud."
	echo


"$@"
