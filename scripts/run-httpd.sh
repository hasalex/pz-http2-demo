#! /bin/bash
docker run  \
    --volume $(pwd)/httpd/httpd.conf:/usr/local/apache2/conf/httpd.conf  \
    --volume $(pwd)/httpd/httpd-h2.conf:/usr/local/apache2/conf/extra/httpd-h2.conf  \
    --volume empty:/usr/local/apache2/conf/extra/httpd-proxy.conf  \
    --volume $(pwd)/ssl/server.crt:/usr/local/apache2/conf/server.crt  \
    --volume $(pwd)/ssl/server.key:/usr/local/apache2/conf/server.key  \
    --volume $(pwd)/images/80:/usr/local/apache2/htdocs/  \
    --rm  \
    --ip 172.44.0.100 \
    --name demo.server  \
    --network demo httpd


#     --volume $(pwd)/ssl/cert.pem:/usr/local/apache2/conf/server.crt  \
#     --volume $(pwd)/ssl/key.pem:/usr/local/apache2/conf/server.key  \
#
