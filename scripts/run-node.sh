#! /bin/bash
docker run  \
    --volume $(pwd)/node:/project \
    --volume $(pwd)/ssl/certs/demo.crt:/ssl/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/ssl/server.key  \
    --volume $(pwd)/images/80:/html \
    --workdir /project \
    --rm --interactive --tty \
    --name demo.server  \
    --ip 172.44.0.100 \
    --network demo  \
    node:8 \
    node index.js

#    node spdy.js
#    node app.js
