#!/bin/bash
source env.sh

echo "------------------------------------------------------------------------------------------------"
echo "---- Create directories for Signing CA"
mkdir -p ca/signing-ca/private ca/signing-ca/db
chmod 700 ca/signing-ca/private
echo "---- Create database for Signing CA"
cp /dev/null ca/signing-ca/db/signing-ca.db
cp /dev/null ca/signing-ca/db/signing-ca.db.attr
echo 01 > ca/signing-ca/db/signing-ca.crt.srl
echo 01 > ca/signing-ca/db/signing-ca.crl.srl
echo "------------------------------------------------------------------------------------------------"


echo "------------------------------------------------------------------------------------------------"
echo "---- Create Signing CA Key"
openssl req -new \
    -config conf/signing-ca.cnf \
    -out ca/signing-ca.csr \
    -passout "pass:$SIGN_CA_PWD" \
    -keyout ca/signing-ca/private/signing-ca.key

echo "---- Create Signing CA Certificate"
openssl ca \
    -config conf/root-ca.cnf \
    -in ca/signing-ca.csr \
    -out ca/signing-ca.crt \
    -subj "$SIGN_CA_DN" \
    -passin "pass:$ROOT_CA_PWD" \
    -batch \
    -extensions signing_ca_ext

rm ca/signing-ca.csr
echo "------------------------------------------------------------------------------------------------"

