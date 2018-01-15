#! /bin/bash

# generate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=localhost'

# remove passphrase
openssl rsa -in key.pem -out key.pem



openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj '/CN=demo'
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
#server certificate does NOT include an ID