#!/bin/bash
CONTAINER=`sudo docker run --detach --rm --network host --security-opt seccomp=unconfined memcached:1.6.22 -t 2`
echo $CONTAINER
