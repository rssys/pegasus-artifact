#!/bin/bash
sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" junction.conf.in  > junction.conf
nohup junction_run junction.conf  -- /usr/local/nginx/sbin/nginx > /dev/null 2>&1 &

