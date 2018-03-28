#! /bin/bash
docker run  \
    --rm -it \
    --name demo.client  \
    --network demo \
    badouralix/curl-http2 $*

# examples
#    h2c avec upgrade : ./scripts/run-curl.sh -v --http2 http://demo.server:8002/hello
#    h2c direct : ./scripts/run-curl.sh -v --http2-prior-knowledge http://demo.server:8002/hello

