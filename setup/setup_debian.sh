#!/bin/bash
sudo apt update
sudo apt install -y build-essential cmake meson libnuma-dev pkg-config python3 python3-pip libmnl-dev libssl-dev libboost-dev clang libseccomp-dev libcli11-dev libibverbs-dev autoconf libpcre3-dev libtool libevent-dev g++-12 gcc-12
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 12
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12
wget https://github.com/rssys/uswitch-kernel/releases/download/v0.1/linux-headers-5.15.74+_5.15.74+-14_amd64.deb
wget https://github.com/rssys/uswitch-kernel/releases/download/v0.1/linux-image-5.15.74+_5.15.74+-14_amd64.deb
sudo apt install ./linux-image-5.15.74+_5.15.74+-14_amd64.deb ./linux-headers-5.15.74+_5.15.74+-14_amd64.deb
sudo pip3 install pyelftools
