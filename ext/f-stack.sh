#!/bin/bash
rm -rf f-stack
git clone https://github.com/F-Stack/f-stack.git
DIR=`pwd`
cd f-stack
git checkout 8020e2669c702fe08d19dc9bc8bf88b3a6da49ae
export FF_PATH=`pwd`
cd lib && make clean && CC=gcc-11 make -j && cd ..
cd app
cd nginx-1.16.1
sed -i -e "s/struct timezone/void/g" src/event/modules/ngx_ff_module.c
./configure --prefix=/usr/local/nginx_fstack --with-ff_module
make
sudo make install
cd ..
cd redis-6.2.6/deps/jemalloc
./autogen.sh
cd ../../
make
sudo cp src/redis-server /usr/local/bin/redis-server-fstack
cd $DIR
sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config-fstack.ini=g" nginx-fstack.conf.in | sudo tee /usr/local/nginx_fstack/conf/nginx.conf > /dev/null
