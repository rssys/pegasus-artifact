#!/bin/bash
sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" redis.conf.in > redis.conf
sudo env MSS=1500 MTU=1500 LIBOS=catnip CONFIG_PATH=$PEGASUS_ROOT/config/config.yaml nohup redis-server-demikernel redis.conf > /dev/null 2>&1 &
