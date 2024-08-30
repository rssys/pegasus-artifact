#!/bin/bash
rm -rf pegasus
git clone https://github.com/rssys/pegasus.git
cd pegasus
git checkout f55df918ffc0aed228bab3b59b213547377f3696
mkdir build
cd build
cmake ..
make -j
sudo cp pegasus runpc /usr/local/bin/
sudo mkdir -p /usr/local/share/pegasus/
sudo cp libhook.so /usr/local/share/pegasus/
cd ../
mkdir build-trace
cd build-trace
cmake .. -DENABLE_TIME_TRACE=On
make -j
sudo cp pegasus /usr/local/bin/pegasus-trace
cd ../../
sudo cp daemon.json /etc/docker/
sudo systemctl restart docker
kubectl apply -f runtimeclass-pegasus.yaml

