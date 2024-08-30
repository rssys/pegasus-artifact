#!/bin/bash
mkdir -p $PEGASUS_ROOT/config
cat config/config.ini | sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" | sed -e "s/CONFIG_PCI/$PEGASUS_PCI_SERVER/g" > $PEGASUS_ROOT/config/config.ini
cat config/config-fstack.ini | sed -e "s/CONFIG_IP/$PEGASUS_IP_SERVER/g" | sed -e "s/CONFIG_PCI/$PEGASUS_PCI_SERVER/g" > $PEGASUS_ROOT/config/config-fstack.ini
cat config/config.yaml | sed -e "s/CONFIG_SERVER_IP/$PEGASUS_IP_SERVER/g" | \
    sed -e "s/CONFIG_PCI/$PEGASUS_PCI_SERVER/g" | sed -e "s/CONFIG_CLIENT_IP/$PEGASUS_IP_CLIENT/g" | \
    sed -e "s/CONFIG_SERVER_MAC/$PEGASUS_MAC_SERVER/g" | sed -e "s/CONFIG_CLIENT_MAC/$PEGASUS_MAC_CLIENT/g" > $PEGASUS_ROOT/config/config.yaml

