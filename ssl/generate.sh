#! /bin/bash

# generate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=localhost'

# remove passphrase
openssl rsa -in key.pem -out key.pem

