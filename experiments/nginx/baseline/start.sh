#!/bin/bash
CONTAINER=`sudo docker run --detach --rm --network host --security-opt seccomp=unconfined pdlan/pegasus-artifact-nginx`
echo $CONTAINER
