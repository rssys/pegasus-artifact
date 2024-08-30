#!/bin/bash
wget https://fast.dpdk.org/rel/dpdk-21.11.2.tar.xz
tar xf dpdk-21.11.2.tar.xz
cd dpdk-stable-21.11.2
meson build
meson configure --default-library static
ninja -C build
sudo ninja -C build install
