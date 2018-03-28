#! /bin/bash

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj '/CN=demo.server' -extfile demo.cnf
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# Pour Tomcat
openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12 -name tomcat

