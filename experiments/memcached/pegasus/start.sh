#!/bin/bash
cat pegasus.conf.in | sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config.ini=g" > pegasus.conf
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
CONTAINER=`sudo docker run --detach --rm --runtime pegasus --entrypoint /usr/local/bin/memcached memcached:1.6.22 -t 2`
echo $PID $CONTAINER
