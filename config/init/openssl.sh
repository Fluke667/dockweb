#!/bin/sh

ENV CA_CRT=/etc/ssl/certs/ca \
CA_CRT_SUBJ="/C=DE/ST=Bavaria/L=Nuremberg/O=CA" \
CRT_SELF=/etc/ssl/certs/self \
CRT_SELF_SUBJ="/C=DE/ST=Bavaria/L=Nuremberg/O=Server/CN=client" \
CRT_SELF_EXT=/etc/ssl/self.ext

echo basicConstraints = CA:FALSE >> ${CRT_SELF_EXT}
echo subjectKeyIdentifier=hash >> ${CRT_SELF_EXT}
echo authorityKeyIdentifier=keyid >> ${CRT_SELF_EXT}

if [ ! -f "$CA_CRT.crt" ]
        then
echo " ---> Generate Root CA private key"
openssl genrsa -out ${CA_CRT}.key 2048
echo " ---> Generate Root CA certificate request"
openssl req -new -key ${CA_CRT}.key -out ${CA_CRT}.csr -subj $CA_CRT_SUBJ
echo " ---> Generate self-signed Root CA certificate"
openssl req -x509 -key ${CA_CRT}.key -in ${CA_CRT}.csr -out ${CA_CRT}.crt -days 3560
openssl req -x509 -key ${CA_CRT}.key -in ${CA_CRT}.csr -out ${CA_CRT}.pem -days 3560
else
  echo "ENTRYPOINT: $CA_CRT.crt already exists"
fi


if [ ! -f "$CRT_SELF.crt" ]
        then
echo " ---> Generate CLI private key"
	openssl genrsa -out ${CRT_SELF}.key 2048
echo " ---> Generate CLI certificate request"
	openssl req  -new -key ${CRT_SELF}.key -out ${CRT_SELF}.csr -subj ${CRT_SELF_SUBJ}
echo " ---> Generate CLI certificate"
	openssl x509 -req -extfile ${CRT_SELF_EXT} -in ${CRT_SELF}.csr -CA ${CA_CRT}.pem -CAkey ${CA_CRT}.key \
		     -CAcreateserial -out ${CRT_SELF}.crt -days 3650 -sha256
else
  echo "ENTRYPOINT: $CRT_SELF.crt already exists"
fi

"$@"
