#!/bin/bash

openssl x509 -req -in development.csr -inform PEM -out development.crt -outform PEM \
             -days 1000000 -CA local-root.crt -CAkey local-root.key -keyform PEM \
             -CAserial ca.srl -CAcreateserial \
             -clrext \
             -extfile openssl.cnf \
             -extensions usr_cert

if [ $? -ne 0 ]; then
  exit 1;
fi

openssl x509 -in development.crt -purpose -noout

if [ $? -ne 0 ]; then
  exit 1;
fi

echo "

"

echo "diffs:"
diff <(openssl x509 -noout -purpose -in github-com.crt) <(openssl x509 -noout -purpose -in development.crt)
