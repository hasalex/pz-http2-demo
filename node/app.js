const express = require('express')
const fs = require('fs')
const http2 = require('http2')

const app = express()
app.get('/hello', (req, res) => res.send('Hello World!'))

const options = {
  key: fs.readFileSync('/ssl/server.key'),
  cert: fs.readFileSync('/ssl/server.crt'),
};

http2.createServer(options, app).listen(8008);
