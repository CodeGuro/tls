#!/bin/sh

exec openssl req -new -out development.csr -outform PEM -key development.key -keyform PEM \
     -subj '/CN=Development/C=US/ST=Area-51/O=Development' \
     -addext 'subjectAltName=DNS:*attlocal.net,DNS:localhost,IP:127.0.0.1,IP:::1' \
     -addext 'keyUsage=digitalSignature' \
     -addext 'basicConstraints=critical,CA:FALSE'

