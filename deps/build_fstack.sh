#!/bin/bash
rm -rf f-stack
git clone https://github.com/rssys/f-stack.git
cd f-stack
git checkout 2b0f691179f57e2bcb23a6f5def86b7dbff4f479
cd dpdk
meson build
meson configure --default-library static
ninja -C build
sudo ninja -C build install
cd ../lib
make clean
CC="gcc-11 -DCONFIG_ENABLE_TIME_TRACE" make -j
sudo cp libfstack.a /usr/local/lib/libfstack-trace.a
make clean
CC=gcc-11 make -j
sudo make install
