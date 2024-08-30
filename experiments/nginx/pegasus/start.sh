#!/bin/bash
cat pegasus.conf.in | sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config.ini=g" > pegasus.conf
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
CONTAINER=`sudo docker run --detach --rm --runtime pegasus pdlan/pegasus-artifact-nginx`
echo $PID $CONTAINER
