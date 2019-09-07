#!/bin/sh

cat >/etc/nginx/sites-enabled/${HOST1_DN}.conf<<EOF
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name $HOST1_DN;
        root /var/www/$HOST1_DN;

	# SSL
	ssl_certificate /etc/letsencrypt/live/$HOST1_DN/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$HOST1_DN/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/$HOST1_DN/chain.pem;

	# security
	include config/security.conf;

	# logging
	error_log /var/log/nginx/$HOST1_DN.error.log warn;

	# index.html fallback
	location / {
		try_files $uri $uri/ /index.html;
	}

	# additional config
	include config/extra.conf;
}

# subdomains redirect
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name *.$HOST1_DN;

	# SSL
	ssl_certificate /etc/letsencrypt/live/$HOST1_DN/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$HOST1_DN/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/$HOST1_DN/chain.pem;

  return 301 https://\$HOST1_DN\$request_uri;
}

# HTTP redirect
server {
	listen 80;
	listen [::]:80;

	server_name .$HOST1_DN;

	include config/letsencrypt.conf;

	location / {
		return 301 https://$HOST1_DN$request_uri;
	}
}
EOF

        echo
        echo -e "${INFO} Domain $HOST1_DN init done. Ready for init $HOST2_DN."
        echo
        
"$@"
