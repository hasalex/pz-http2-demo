#!/bin/bash
source env.sh

echo "------------------------------------------------------------------------------------------------"
echo "---- Create directories for Root CA"
mkdir -p ca/root-ca/private ca/root-ca/db
chmod 700 ca/root-ca/private
echo "---- Create database for Root CA"
cp /dev/null ca/root-ca/db/root-ca.db
cp /dev/null ca/root-ca/db/root-ca.db.attr
echo 01 > ca/root-ca/db/root-ca.crt.srl
echo 01 > ca/root-ca/db/root-ca.crl.srl
echo "------------------------------------------------------------------------------------------------"

echo "------------------------------------------------------------------------------------------------"
echo "---- Create Root CA Key"
openssl req -new \
    -config conf/root-ca.cnf \
    -out ca/root-ca.csr \
    -passout "pass:$ROOT_CA_PWD" \
    -keyout ca/root-ca/private/root-ca.key

echo "---- Create Root CA Certificate"
openssl ca -selfsign \
    -config conf/root-ca.cnf \
    -in ca/root-ca.csr \
    -out ca/root-ca.crt \
    -subj "$ROOT_CA_DN" \
    -passin "pass:$ROOT_CA_PWD" \
    -batch \
    -extensions root_ca_ext

rm ca/root-ca.csr
echo "------------------------------------------------------------------------------------------------"

