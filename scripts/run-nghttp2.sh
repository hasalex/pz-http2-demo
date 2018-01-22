#! /bin/bash
mode=$1

docker_cmd="docker run --volume $(pwd)/ssl/server.crt:/ssl/server.crt --volume $(pwd)/ssl/server.key:/ssl/server.key --volume $(pwd)/images/160:/html --rm -it --name demo.server --network demo svagi/nghttp2"

if [ 'x'$mode = 'xssl' ]
then
    echo Start with TLS on port 8003
    $docker_cmd nghttpd -d /html 8003 /ssl/server.key /ssl/server.crt
else
    echo Start without TLS on port 8001
    $docker_cmd nghttpd --no-tls -d /html 8001
fi

