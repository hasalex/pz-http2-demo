#! /bin/bash
docker run  \
    --rm -it \
    --name demo.client  \
    --network demo \
    badouralix/curl-http2 $*

