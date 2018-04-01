#!/bin/bash
ROOT_CA_DN="/DC=sewatech/O=Sewatech/CN=Sewatech Root CA"
ROOT_CA_PWD="rootpwd"

SIGN_CA_DN="/DC=sewatech/O=Sewatech/CN=Sewatech Signing CA"
SIGN_CA_PWD="signpwd"

SERVER_DN="/DC=sewatech/O=Sewatech/CN=Sewatech Demo"
SERVER_KEY_PWD="demopwd"
SERVER_P12_PWD="p12pwd"

export SAN="DNS:demo.proxy, DNS:demo.server, DNS:slide.server"

