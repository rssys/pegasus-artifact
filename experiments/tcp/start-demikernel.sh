#!/bin/bash
sudo env MSS=1500 MTU=1500 LIBOS=catnip CONFIG_PATH=$PEGASUS_ROOT/config/config.yaml nohup ./3 --server $PEGASUS_IP_SERVER 8000 > /dev/null 2>&1 &
PID=$!
echo $PID
