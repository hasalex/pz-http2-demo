#! /bin/bash
docker run  \
    --volume $(pwd)/node:/project \
    --volume $(pwd)/ssl:/ssl \
    --volume $(pwd)/images:/images \
    --workdir /project \
    --rm -i -t \
    --name demo.server  \
    --network demo  \
    node:8 \
    node spdy.js

