const http = require('http'),
      https = require('https'),
      http2 = require('http2'),
      fs = require('fs');

const docRoot = '/html';

const options = {
  key: fs.readFileSync('/ssl/server.key'),
  cert: fs.readFileSync('/ssl/server.crt'),
  allowHTTP1: true 
};

const requestHandler = (request, response) => {
    if (request.url == '/') {
      answer("/index.html", response);
    } else if (request.url == '/push') {
      push("/index.html", response);
    } else {
      answer(request.url, response);
    }
}

const server1 = http.createServer(requestHandler);
const portH1 = 8001;
server1.listen(portH1, (err) => {
  if (err) {
    console.log('HTTP/1 server fail', err);
  } else {
    console.log(`HTTP/1 server is listening on ${portH1}`);
  }
});

const server2c = http2.createServer(requestHandler);
const portH2C = 8002;
server2c.listen(portH2C, (err) => {
  if (err) {
    console.log('HTTP/2 clear text server fail', err);
  } else {
    console.log(`HTTP/2 clear text server is listening on ${portH2C}`);
  }
});

const server2 = http2.createSecureServer(options, requestHandler);
const portH2 = 8003;
server2.listen(portH2, (err) => {
  if (err) {
    console.log('HTTP/2 server fail', err);
  } else {
    console.log(`HTTP/2 server is listening on ${portH2}`);
  }
});

function answer(url, response) {
  fs.readFile(docRoot + url, function(err, file) {
    if (err) {        
        response.writeHead(500, {"Content-Type": "text/plain"});
        response.write(err + '\n');
        response.end();
        return;
    }
    response.end(file);
  });
}

function push(url, response) {
  if (response.stream) {
    fs.readdir(docRoot, (err, files) => {
      files
        .filter(element => !element.endsWith('.html'))
        .forEach(element => {
          const file = '/' + element;
          response.stream.pushStream({":path": file}, (pushStream) => {
            pushStream.respondWithFile(docRoot + file);
          });
        });
      response.stream.respondWithFile(docRoot + url);
    });
  } else {
    response.writeHead(500, {"Content-Type": "text/plain"});
    response.write('Push not supported\n');
    response.end();
  }
}
