#!/bin/sh

cat >/etc/nginx/sites-enabled/${HOST3_DN}.conf<<EOF
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        server_name $HOST3_DN;
        root /var/www/$HOST3_DN;

        # SSL
        ssl_certificate /etc/letsencrypt/live/$HOST3_DN/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$HOST3_DN/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/$HOST3_DN/chain.pem;

        # security
        include config/security.conf;

        # logging
        error_log /var/log/nginx/$HOST3_DN.error.log warn;

        # index.html fallback
        location / {
                try_files \$uri \$uri/ /index.html;
        }

        # additional config
        include config/extra.conf;
}

# subdomains redirect
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        server_name *.$HOST3_DN;

        # SSL
        ssl_certificate /etc/letsencrypt/live/$HOST3_DN/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$HOST3_DN/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/$HOST3_DN/chain.pem;

    return 301 https://\$host\$request_uri;
}

# HTTP redirect
server {
        listen 80;
        listen [::]:80;

        server_name .$HOST3_DN;

        include config/letsencrypt.conf;

        location / {
                return 301 https://\$host\$request_uri;
        }
}
EOF

        echo
        echo -e "${INFO} Domain $HOST3_DN init done. Ready for init Nginx."
        echo

"$@"
