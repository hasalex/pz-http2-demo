#! /bin/bash
docker run  \
    --volume $(pwd)/nginx/h2.conf:/etc/nginx/conf.d/h2.conf  \
    --volume $(pwd)/ssl/certs/demo.crt:/etc/nginx/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/etc/nginx/server.key  \
    --volume $(pwd)/images/80:/usr/share/nginx/html  \
    --rm  \
    --name demo.server  \
    --ip 172.44.0.100 \
    --network demo \
    nginx
