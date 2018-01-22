// Exemple avec https://github.com/molnarg/node-http2 (déprécié)
const express = require('express')
const fs = require('fs')
const app = express()
const http2 = require('spdy')

app.get('/', (req, res) => res.send('Hello World!'))

const options = {
  key: fs.readFileSync('/ssl/server.key'),
  cert: fs.readFileSync('/ssl/server.crt'),
  allowHTTP1: true 
};

http2.createServer(options, app).listen(8008);

const requestHandler = (request, response) => {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write('Helloxxx');
    response.end();
    return;
}
http2.createServer(options, requestHandler).listen(8009);

