#!/bin/bash
sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" redis.conf.in  > redis.conf
sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" junction.conf.in  > junction.conf
nohup junction_run junction.conf  -- /usr/local/bin/redis-server-6.2.6 redis.conf > /dev/null 2>&1 &

