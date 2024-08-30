#!/bin/bash
sudo docker kill $2 --signal=SIGKILL
sudo kill $1
sudo pkill -x runpc
sudo pkill -x pegasus
