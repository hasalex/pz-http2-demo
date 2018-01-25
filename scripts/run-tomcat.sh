#! /bin/bash
jre_version=$1

docker run  \
    --volume $(pwd)/tomcat/server.xml:/usr/local/tomcat/conf/server.xml  \
    --volume $(pwd)/ssl/server.crt:/usr/local/tomcat/conf/server.crt  \
    --volume $(pwd)/ssl/server.key:/usr/local/tomcat/conf/server.key  \
    --volume $(pwd)/ssl/server.p12:/usr/local/tomcat/conf/server.p12  \
    --volume $(pwd)/images/80:/usr/local/tomcat/webapps/ROOT  \
    --rm  \
    --ip 172.44.0.100 \
    --name demo.server  \
    --network demo \
    tomcat:9-jre${jre_version:-9}

