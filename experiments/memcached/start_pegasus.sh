#!/bin/bash
cat pegasus.conf.in | sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config.ini=g" > pegasus.conf
sudo pegasus pegasus.conf
