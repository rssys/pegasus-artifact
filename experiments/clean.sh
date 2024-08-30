#!/bin/bash
rm -f redis/pegasus/pegasus.conf redis/junction/junction.conf redis/junction/redis.conf redis/demikernel/redis.conf 
rm -f memcached/pegasus/pegasus.conf memcached/junction/junction.conf
rm -f nginx/pegasus/pegasus.conf nginx/junction/junction.conf
rm -f proxy/pegasus.conf
cd microbenchmark && ./clean.sh && cd ..
cd tcp && ./clean.sh && cd ..
