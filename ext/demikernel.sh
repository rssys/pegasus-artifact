#!/bin/bash
scp $PEGASUS_IP_SERVER:/usr/local/lib/libdemikernel.so /tmp/
sudo cp /tmp/libdemikernel.so /usr/local/lib/
sudo ldconfig
