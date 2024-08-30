#!/bin/bash
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages > /dev/null
sudo mkdir /mnt/huge -p
sudo mount -t hugetlbfs nodev /mnt/huge
