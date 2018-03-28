#! /bin/bash
CERT_PASS="pass:xxx"
CA_PASS="pass:test"

openssl genrsa -des3 -passout $CERT_PASS -out server.pass.key 2048
openssl rsa -passin $CERT_PASS -in server.pass.key -out server.key
rm server.pass.key

openssl req -new -key server.key -out server.csr -nodes -sha256 -subj "/O=Sewatech/CN=demo.server" -config demo.cnf
#openssl req -new -key server.key -out server.csr -config demo.cnf
#openssl ca -config demo.cnf -cert CA/CAcert.pem -keyfile CA/private/CAkey.pem -passin "$CA_PASS" -policy policy_anything -out cert/cert.pem -infiles cert/certreq.pem
openssl x509 -extensions v3_req -req -days 365 -in server.csr -signkey server.key -out server.crt -extfile demo.cnf

# Pour Tomcat
openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12 -name tomcat

