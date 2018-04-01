#! /bin/bash
mode=$1

docker_cmd="docker run --volume $(pwd)/ssl/certs/demo.crt:/ssl/server.crt --volume $(pwd)/ssl/certs/demo.key:/ssl/server.key --volume $(pwd)/images/160:/html --rm -it --ip 172.44.0.100 --name demo.server --network demo svagi/nghttp2"

if [ 'x'$mode = 'xssl' ]
then
    echo Start with TLS on port 8003
    $docker_cmd nghttpd -d /html 8003 /ssl/server.key /ssl/server.crt
else
    echo Start without TLS on port 8002
    $docker_cmd nghttpd --no-tls -d /html 8002
fi

