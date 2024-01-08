#!/bin/sh

# generate the server private key
KEYNAME=development.key
openssl genpkey -out "${KEYNAME}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -pkeyopt ec_param_enc:named_curve
if [ $? -ne 0 ]; then
  echo "Failed private key generation"
  exit 1
fi
echo "generated server private key: ${KEYNAME}"

# generate the server certificate request
REQNAME=development.crt
openssl req -new -keyform PEM -key "${KEYNAME}" -config openssl.cnf -reqexts v3_req -out "${REQNAME}" -subj "/CN=Development/C=US/ST=Area-51/O=Local Development Team"
if [ $? -ne 0 ]; then
  echo "Failed certificate key generation"
  exit 1
fi
echo -e "generated server certificate request: ${REQNAME}\n"
openssl req -noout -text -in "${REQNAME}"
