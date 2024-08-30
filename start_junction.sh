#!/bin/bash
source env.sh
cd ext/junction
sudo lib/caladan/scripts/setup_machine.sh
sudo dpdk-devbind.py -b vfio-pci $PEGASUS_PCI_SERVER --force
sudo nohup lib/caladan/iokerneld ias vfio nicpci $PEGASUS_PCI_SERVER &
