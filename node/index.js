const https = require('https'),
      http2 = require('http2'),
      fs = require('fs');

const latency = 300;
const home = '/home/alexis/Projet/http2';
const docRoot = home + '/images/160';

const options = {
  key: fs.readFileSync(home + '/ssl/server.key'),
  cert: fs.readFileSync(home + '/ssl/server.crt')
};

const requestHandler = (request, response) => {
    if (request.url == '/') {
        response.writeHead(302, {"Location": "/dino.html"});
        response.end();
        return;
    }

    fs.readFile(docRoot + request.url, function(err, file) {
        if(err) {        
            response.writeHead(500, {"Content-Type": "text/plain"});
            response.write(err + '\n');
            response.end();
            return;
        }
        setTimeout(() => {response.end(file)}, latency);
    });
}

const server1 = https.createServer(options, requestHandler);
const portH1 = 8001;
server1.listen(portH1, (err) => {
  if (err) {
    console.log('HTTP/1 server fail', err);
  } else {
    console.log(`HTTP/1 server is listening on ${portH1}`);
  }
});

const server2 = http2.createSecureServer(options, requestHandler);
const portH2 = 8002;
server2.listen(portH2, (err) => {
  if (err) {
    console.log('HTTP/2 server fail', err);
  } else {
    console.log(`HTTP/2 server is listening on ${portH2}`);
  }
});

const requestHandlerWithPush = (request, response) => {
    if (request.url == '/') {
      response.writeHead(302, {"Location": "/dino.html"});
      response.end();
      return;
    } else if (request.url == '/dino.html') {
      const pushHeaders = {
        ':status': '200',
        'content-type': 'image/jpg'
      };

      fs.readdir(docRoot, (err, files) => {
        files
          .filter(element => !element.endsWith('.html'))
          .forEach(element => {
            const file = '/' + element;
            response.stream.pushStream({":path": file}, (pushStream) => {
              pushStream.respondWithFile(docRoot + file);
            });
          });
        setTimeout(() => {response.stream.respondWithFile(docRoot + '/dino.html')}, latency);
      });

    } else {
      fs.readFile(docRoot + request.url, function(err, file) {
        if(err) {        
          response.writeHead(500, {"Content-Type": "text/plain"});
          response.write(err + '\n');
          response.end();
          return;
        }
        setTimeout(() => {response.end(file)}, latency);
      });
    }
}

const server2push = http2.createSecureServer(options, requestHandlerWithPush);
const portH2push = 8003;
server2push.listen(portH2push, (err) => {
  if (err) {
    console.log('HTTP/2 (push) server fail', err);
  } else {
    console.log(`HTTP/2 (push) server is listening on ${portH2push}`);
  }
});
