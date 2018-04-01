#! /bin/bash
docker run  \
    --volume $(pwd)/httpd/httpd.conf:/usr/local/apache2/conf/httpd.conf  \
    --volume $(pwd)/httpd/httpd-h2.conf:/usr/local/apache2/conf/extra/httpd-h2.conf  \
    --volume $(pwd)/httpd/httpd-proxy.conf:/usr/local/apache2/conf/extra/httpd-proxy.conf  \
    --volume $(pwd)/ssl/certs/demo.crt:/usr/local/apache2/conf/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/usr/local/apache2/conf/server.key  \
    --rm  \
    --ip 172.44.0.101 \
    --name demo.proxy  \
    --network demo httpd


#     --volume $(pwd)/ssl/cert.pem:/usr/local/apache2/conf/server.crt  \
#     --volume $(pwd)/ssl/key.pem:/usr/local/apache2/conf/server.key  \
#
