#!/bin/bash
cat config-fstack.ini.in | sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" | sed -e "s/CONFIG_PCI/$PEGASUS_PCI_SERVER/g" > config-fstack.ini
sudo nohup ./1 server --conf ./config-fstack.ini > /dev/null 2>&1 &
PID=$!
echo $PID
