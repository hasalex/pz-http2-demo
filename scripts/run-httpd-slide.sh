#! /bin/bash
docker run  \
    --volume $(pwd)/httpd/httpd.conf:/usr/local/apache2/conf/httpd.conf  \
    --volume $(pwd)/httpd/httpd-h2.conf:/usr/local/apache2/conf/extra/httpd-h2.conf  \
    --volume empty:/usr/local/apache2/conf/extra/httpd-proxy.conf  \
    --volume $(pwd)/ssl/certs/demo.crt:/usr/local/apache2/conf/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/usr/local/apache2/conf/server.key  \
    --volume $(pwd)/images/80:/usr/local/apache2/htdocs/  \
    --rm  \
    --name slide.server  \
    --network demo \
    --ip 172.44.0.99 \
    httpd

