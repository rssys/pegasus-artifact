#!/bin/bash
cd redis
./exp-pegasus.sh
sleep 10
cd ../nginx
./exp-pegasus.sh
sleep 10
cd ../memcached
./exp-pegasus.sh
sleep 10
cd ../tcp
./exp-pegasus.sh
sleep 10
./exp-pegasus-trace.sh
sleep 10
cd ../proxy
./exp-pegasus.sh allopt
sleep 10
./exp-pegasus.sh novtcp
sleep 10
./exp-pegasus.sh nodpdk
sleep 10
cd ../local-proxy
./exp-pegasus.sh
sleep 10
cd ../web
./exp-pegasus.sh
sleep 10
cd ../servicemesh
./exp-pegasus.sh
sleep 10
