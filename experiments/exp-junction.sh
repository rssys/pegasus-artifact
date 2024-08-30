#!/bin/bash
cd redis
./exp-junction.sh
cd ..
cd nginx
./exp-junction.sh
cd ..
cd memcached
./exp-junction.sh
cd ..
