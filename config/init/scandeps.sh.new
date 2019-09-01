#!/bin/sh

PHPDEPS="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/lib \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
      
      
      echo 
