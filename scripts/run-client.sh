#! /bin/bash
docker run  \
    --rm -it \
    --name demo.client  \
    --network demo \
    ubuntu:17.10
