#!/bin/bash
rm -rf redis/data nginx/data memcached/data proxy/data web/data local-proxy/data servicemesh/data tcp/data
rm -f redis/pegasus.conf nginx/pegasus.conf memcached/pegasus.conf proxy/pegasus.conf tcp/pegasus.conf tcp/config.yaml tcp/junction.conf tcp/config-fstack.ini
cd results && ./clean.sh && cd ..
