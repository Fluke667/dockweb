#!/bin/sh

cat >/etc/nginx/sites-enabled/${HOST2_DN}.conf<<EOF
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        server_name $HOST2_DN;
        root /var/www/$HOST2_DN;

        # SSL
        ssl_certificate /etc/letsencrypt/live/$HOST2_DN/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$HOST2_DN/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/$HOST2_DN/chain.pem;

        # security
        include config/security.conf;

        # logging
        error_log /var/log/nginx/$HOST2_DN.error.log warn;

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

        server_name *.$HOST2_DN;

        # SSL
        ssl_certificate /etc/letsencrypt/live/$HOST2_DN/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$HOST2_DN/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/$HOST2_DN/chain.pem;

    return 301 https://\$host\$request_uri;
}

# HTTP redirect
server {
        listen 80;
        listen [::]:80;

        server_name .$HOST2_DN;

        include config/letsencrypt.conf;

        location / {
                return 301 https://\$host\$request_uri;
        }
}
EOF

        echo
        echo -e "${INFO} Domain $HOST2_DN init done. Ready for init $HOST3_DN."
        echo

"$@"
