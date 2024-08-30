#!/bin/bash
cd redis
./exp-baseline.sh
cd ../nginx
./exp-baseline.sh
cd ../memcached
./exp-baseline.sh
cd ../tcp
./exp-baseline.sh
cd ../proxy
./exp-baseline.sh
cd ../local-proxy
./exp-baseline.sh
cd ../web
./exp-baseline.sh
cd ../servicemesh
./exp-baseline.sh
