#!/bin/bash
source env.sh

echo "------------------------------------------------------------------------------------------------"
echo "---- Create certificate directories"
mkdir -p certs

echo "------------------------------------------------------------------------------------------------"
echo "---- Create Server Key"
openssl req -new \
    -config conf/demo.cnf \
    -out certs/demo.csr \
    -subj "$SERVER_DN" \
    -passout "pass:$SERVER_KEY_PWD" \
    -keyout certs/demo.key

echo "---- Create Server Certificate"
openssl ca \
    -config conf/signing-ca.cnf \
    -in certs/demo.csr \
    -out certs/demo.crt \
    -passin "pass:$SIGN_CA_PWD" \
    -batch \
    -extensions server_ext

rm certs/demo.csr

echo "---- Export PKCS#12 certificate"
openssl pkcs12 -export \
    -inkey certs/demo.key \
    -in certs/demo.crt \
    -passout "pass:$SERVER_P12_PWD" \
    -out certs/demo.p12
echo "------------------------------------------------------------------------------------------------"

