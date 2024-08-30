#!/bin/bash
mkdir -p tmp
cd tmp
scp $PEGASUS_IP_SERVER:/usr/local/bin/runpc .
scp $PEGASUS_IP_SERVER:/usr/local/bin/pegasus .
scp $PEGASUS_IP_SERVER:/usr/local/share/pegasus/libhook.so .
scp $PEGASUS_IP_SERVER:/etc/docker/daemon.json .
sudo cp runpc pegasus /usr/local/bin/
sudo mkdir -p /usr/local/share/pegasus
sudo cp libhook.so /usr/local/share/pegasus/
sudo cp daemon.json /etc/docker/
sudo systemctl restart docker
cd ..
rm -rf tmp
