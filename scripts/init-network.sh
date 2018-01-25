#! /bin/bash
network_name=demo
docker network create  \
    -o "com.docker.network.bridge.name"="br-$network_name" \
    --subnet=172.44.0.0/16 \
    $network_name
#docker network rm demo

# Latency : http://bencane.com/2012/07/16/tc-adding-simulated-network-latency-to-your-linux-server/
#sudo tc qdisc list
#sudo tc qdisc del dev br-demo root
sudo tc qdisc add dev br-$network_name root handle 1:0 netem delay 80msec
