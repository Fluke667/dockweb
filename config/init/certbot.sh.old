#!/bin/sh

HOST_EMAIL=Fluke667@gmail.com
HOST1_DN=fluke667.host
HOST1_DIR=/etc/ssl/certs/
HOST2_DN=fluke667.host
HOST2_DIR=/etc/ssl/certs/
HOST3_DN=fluke667.host
HOST3_DIR=/etc/ssl/certs/

if [ -z "${HOST1_DN}" ]; then
   echo " ---> ERROR: Domain Name is Mandatory"
elif [ -z "${HOST_EMAIL}" ]; then
   echo " ---> ERROR: Email Adress is Mandatory"
else
mkdir -p ${HOST1_DIR}/${HOST1_DN} &
exec certbot certonly --noninteractive --quiet --nginx --agree-tos --email="${HOST_EMAIL}" -d "${HOST1_DN}, www.${HOST1_DN}" --cert-path ${HOST1_DIR}/${HOST1_DN}/cert.pem --key-path ${HOST1_DIR}/${HOST1_DN}/privkey.pem --chain-path ${HOST1_DIR}/${HOST1_DN}/chain.pem --fullchain-path ${HOST1_DIR}/${HOST1_DN}/fullchain.pem
fi


"$@"
