#! /bin/bash
docker_cmd="docker run --volume $(pwd)/ssl/certs/demo.crt:/ssl/server.crt --volume $(pwd)/ssl/certs/demo.key:/ssl/server.key --rm -it --ip 172.44.0.101 --name demo.proxy --network demo svagi/nghttp2"

echo Start with TLS on port 8003
#$docker_cmd nghttpx --frontend='0.0.0.0,8003' -b 'demo.server,8001' /ssl/server.key /ssl/server.crt
$docker_cmd nghttpx --frontend='0.0.0.0,8003' -b 'demo.server,8002;;proto=h2' -k /ssl/server.key /ssl/server.crt
#$docker_cmd nghttpx --frontend='0.0.0.0,8003' -b 'demo.server,8003;;tls' -k /ssl/server.key /ssl/server.crt
#$docker_cmd nghttpx --frontend='0.0.0.0,8003' -b 'google.fr,8004;;proto=h2;tls' /ssl/server.key /ssl/server.crt

