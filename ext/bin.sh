#!/bin/bash
rm -f nginx-1.16.1.tar.gz
wget https://nginx.org/download/nginx-1.16.1.tar.gz
tar xzvf nginx-1.16.1.tar.gz
cd nginx-1.16.1
./configure
make -j
sudo make install
cd ..
sudo bash -c 'sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" nginx-junction.conf.in > /usr/local/nginx/conf/nginx.conf'
sudo cp memcached-1.6.22 /usr/local/bin/
sudo cp redis-server-6.2.6 /usr/local/bin/
