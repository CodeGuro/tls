#!/bin/sh

# generate the server private key
PREFIX=development
KEYNAME=${PREFIX}.key
openssl genpkey -out "${KEYNAME}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -pkeyopt ec_param_enc:named_curve
if [ $? -ne 0 ]; then
  echo "Failed private key generation"
  exit 1
fi
echo "generated server private key: ${KEYNAME}"

# generate the server certificate request
REQNAME=${PREFIX}.csr
openssl req -new -keyform PEM -key "${KEYNAME}" -config openssl.cnf -reqexts v3_req -out "${REQNAME}" -subj "/CN=Development/C=US/ST=Area-51/O=Local Development Team"
if [ $? -ne 0 ]; then
  echo "Failed certificate key generation"
  exit 1
fi
# print the certificate request details
echo -e "generated server certificate request: ${REQNAME}\n"
openssl req -noout -text -in "${REQNAME}"

# generate the server certificate from the server certificate request
CRTNAME=${PREFIX}.crt
openssl x509 -req -inform PEM -in "${REQNAME}" -outform PEM -out "${CRTNAME}" -preserve_dates -CA local-root.crt -CAkey local-root.key -CAcreateserial -extfile openssl.cnf -extensions usr_cert
if [ $? -ne 0 ]; then
  echo "FAiled server certificate generation"
  exit 1
fi
# print the certificate details
echo -e "generated server certificate: ${CRTNAME}\n"
openssl x509 -in "${CRTNAME}" -noout -purpose -text

# copy and install the server certificate
if ! sudo cp "${CRTNAME}" /usr/local/share/ca-certificates/; then
  echo "Failed to install server certificate"
  exit 1
fi

if ! sudo update-ca-certificates --fresh >/dev/null; then
  echo "Failed to update server certificates"
  exit 1
fi