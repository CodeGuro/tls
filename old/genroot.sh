#!/bin/sh

#openssl genrsa -out local-root.key 2048
#openssl req -x509 -new -nodes -key local-root.key -sha256 -days 1000000 -out local-root.crt -subj "/C=US/O=Development/CN=Development"
openssl req -x509 -new -nodes -key local-root.key -sha256 -days 1825 -out local-root.crt
sudo cp local-root.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

