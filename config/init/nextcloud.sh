#!/bin/sh

cat >/var/www/nextcloud/config/config.php <<-EOF



"$@"
