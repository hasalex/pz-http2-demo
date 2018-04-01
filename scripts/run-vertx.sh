#! /bin/bash
jre_version=$1

docker run  \
    --volume $(pwd)/vertx:/project \
    --volume $(pwd)/ssl/certs/demo.crt:/ssl/server.crt  \
    --volume $(pwd)/ssl/certs/demo.key:/ssl/server.key  \
    --volume $(pwd)/images/80:/images \
    --volume mvn_repo:/root/.m2/repository \
    --workdir /project \
    --rm  \
    --name demo.server \
    --ip 172.44.0.100 \
    --network demo -it \
    maven:3.5-jdk-${jre_version:-9} \
    mvn clean package exec:exec -Dssl.home=/ssl/ $2

# Use host mvn repo : be careful to files' owner (root)
#    --volume ~/.m2/repository:/root/.m2/repository \

# Fix SSL issue in JDK-9 image : https://github.com/docker-library/openjdk/issues/145
#curl --silent --show-error --location --fail --retry 3 \ 
#     --output /etc/ssl/certs/java/cacerts \
#     https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/openjdk-9-slim-cacerts; \

# Clean the root owned files
docker run  \
    --volume $(pwd)/vertx:/project \
    --volume $(pwd)/ssl:/ssl \
    --volume ~/.m2/repository:/root/.m2/repository \
    --workdir /project \
    --rm  \
    --name demo.server  \
    --ip 172.44.0.100 \
    --network demo \
    maven:3.5-jdk-${jre_version:-9} \
    mvn clean

