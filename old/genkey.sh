#!/bin/sh

exec openssl genpkey -outform PEM -out development.key \
  -algorithm EC -pkeyopt ec_paramgen_curve:secp384r1 \
  -pkeyopt ec_param_enc:named_curve

#openssl genrsa -out development.key 2048
