#!/bin/sh
SSLEAY_CONFIG="-config demo.cnf"
ROOTCA_SUBJ="-subj /C=FR/O=Sewatech/CN=RootCA/emailAddress=rootca@sewatech.fr"
CERT_SUBJ="-subj /C=US/ST=abc/L=abc/O=test/OU=mine/CN=cert/emailAddress=cert@example.org"
ROOTCA_PASS="pass:test"
CA_PASS="pass:test"
CERT_PASS="pass:test"
DIR="demoCA"
mkdir "$DIR" "$DIR"/certs "$DIR"/crl "$DIR"/newcerts "$DIR"/private
touch "$DIR"/index.txt
echo 01 > "$DIR"/crlnumber

# create Root CA
mkdir rootCA rootCA/certs rootCA/crl rootCA/newcerts rootCA/private
openssl req $SSLEAY_CONFIG -new -keyout rootCA/private/rootCAkey.pem -out rootCA/rootCAreq.pem -subj /C=FR/O=Sewatech/CN=RootCA/emailAddress=rootca@sewatech.fr -passout "$ROOTCA_PASS"
openssl ca $SSLEAY_CONFIG -create_serial -out rootCA/rootCAcert.pem -days 1095 -batch -keyfile rootCA/private/rootCAkey.pem -passin "$ROOTCA_PASS" -selfsign -extensions v3_ca -infiles rootCA/rootCAreq.pem

# create Intermediate CA
mkdir CA CA/certs CA/crl CA/newcerts CA/private
openssl req $SSLEAY_CONFIG -new -keyout CA/private/CAkey.pem -out CA/CAreq.pem -days 365 $CA_SUBJ -passout "$CA_PASS"
openssl ca $SSLEAY_CONFIG -cert rootCA/rootCAcert.pem -keyfile rootCA/private/rootCAkey.pem -passin "$ROOTCA_PASS" -policy policy_anything -out CA/CAcert.pem -extensions v3_ca -infiles CA/CAreq.pem

# create Final Cert
mkdir cert cert/private
openssl req $SSLEAY_CONFIG -new -keyout cert/private/certkey.pem -out cert/certreq.pem -days 365 $CERT_SUBJ -passout "$CERT_PASS"
openssl ca $SSLEAY_CONFIG -cert CA/CAcert.pem -keyfile CA/private/CAkey.pem -passin "$CA_PASS" -policy policy_anything -out cert/cert.pem -infiles cert/certreq.pem
cat rootCA/rootCAcert.pem CA/CAcert.pem > myCA.pem
openssl verify -CAfile myCA.pem cert/cert.pem
