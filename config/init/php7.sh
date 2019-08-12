#!/bin/sh



echo "extension=redis.so" > /etc/php7/php.ini
echo "extension=smbclient.so" > /etc/php7/php.ini


cat >/etc/php7/conf.d/apcu.ini<<-EOF
extension=apcu.so
apc.enabled=1
apc.shm_size=<APC_SHM_SIZE>
apc.ttl=7200
EOF

cat >/etc/php7/conf.d/smbclient.ini<<EOF
extension=smbclient.so
EOF

cat >/etc/php7/conf.d/opcache.ini<<EOF
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.fast_shutdown=1
opcache.memory_consumption=<OPCACHE_MEM_SIZE>
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.revalidate_freq=60
EOF

"$@"
