#! /bin/bash
docker run  \
    --volume $(pwd)/nginx/ssl.conf:/etc/nginx/conf.d/ssl.conf  \
    --volume $(pwd)/nginx/h2c.conf:/etc/nginx/conf.d/h2c.conf  \
    --volume $(pwd)/ssl/server.crt:/etc/nginx/server.crt  \
    --volume $(pwd)/ssl/server.key:/etc/nginx/server.key  \
    --volume $(pwd)/images/160:/usr/share/nginx/html  \
    --rm  \
    --name demo.server  \
    --network demo \
    nginx
