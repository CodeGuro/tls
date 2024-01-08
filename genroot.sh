#!/bin/sh

# generate the root private key
KEYNAME=local-root.key
openssl genpkey -out "${KEYNAME}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -pkeyopt ec_param_enc:named_curve
if [ $? -ne 0 ]; then
  echo "Failed private key generation"
  exit 1
fi
echo "generated root private key: ${KEYNAME}"

# generate the root signing certificate
CRTNAME=local-root.crt
openssl req -x509 -keyform PEM -key "${KEYNAME}" -days 1000000 -config openssl.cnf -extensions v3_local_ca -out "${CRTNAME}" -subj "/CN=Development"
if [ $? -ne 0 ]; then
  echo "Failed root certificate generation"
  exit 1
fi
echo "generated root certificate: ${CRTNAME}\n\n"

# print out the root certificate details
openssl x509 -noout -purpose -text -in "${CRTNAME}"

if ! sudo cp "${CRTNAME}" /usr/local/share/ca-certificates/; then
  echo "Failed to install root certificate"
  exit 1
fi

if ! sudo update-ca-certificates --fresh >/dev/null; then
  echo "Failed to update root certificates"
  exit 1
fi