#! /bin/bash
docker run  \
    --volume $(pwd)/node:/project \
    --volume $(pwd)/ssl:/ssl \
    --volume $(pwd)/images:/images \
    --workdir /project \
    --rm -i -t \
    --name demo.server  \
    --ip 172.44.0.100 \
    --network demo  \
    node:8 \
    node index.js

#    node spdy.js

