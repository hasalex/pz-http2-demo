#! /bin/bash
jre_version=$1

docker run  \
    --volume $(pwd)/vertx:/project \
    --volume $(pwd)/ssl/certs/demo.crt:/ssl/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/ssl/server.key  \
    --volume $(pwd)/images/80:/images \
    --volume mvn_repo:/home/demo/.m2/repository \
    --workdir /project \
    --rm  \
    --name demo.server \
    --ip 172.44.0.100 \
    --network demo -it \
    maven:3.5-jdk-${jre_version:-10} \
    /project/run-in-docker.sh
