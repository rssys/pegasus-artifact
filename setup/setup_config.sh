#!/bin/bash
mkdir -p $PEGASUS_ROOT/config
cat config/config.ini | sed -e "s/CONFIG_IP/$PEGASUS_IP_CLIENT/g" | sed -e "s/CONFIG_PCI/$PEGASUS_PCI_CLIENT/g" > $PEGASUS_ROOT/config/config.ini
