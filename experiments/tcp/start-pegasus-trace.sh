#!/bin/bash
cat pegasus-trace.conf.in | sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config.ini=g" > pegasus-trace.conf
setsid sudo pegasus-trace pegasus-trace.conf > /dev/null 2>&1 &
PID=$!
sleep 5
CONTAINER=`sudo docker run --detach --rm --runtime pegasus --entrypoint /usr/local/bin/tcp-trace pdlan/pegasus-artifact-tcp server`
echo $PID $CONTAINER
