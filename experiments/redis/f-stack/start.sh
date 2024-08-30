#!/bin/bash
sudo nohup redis-server-fstack --conf=$PEGASUS_ROOT/config/config.ini -- -- -- redis.conf > /dev/null 2>&1 &
