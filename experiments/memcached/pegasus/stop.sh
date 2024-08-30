#!/bin/bash
sudo docker kill $2
sudo kill $1
sudo pkill -x runpc
sudo pkill -x pegasus
