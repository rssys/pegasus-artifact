#!/bin/bash
rm -rf liburing-2.7.tar.gz liburing-liburing-2.7
wget https://github.com/axboe/liburing/archive/refs/tags/liburing-2.7.tar.gz
tar xzf liburing-2.7.tar.gz
cd liburing-liburing-2.7
./configure
make -j
sudo make install
