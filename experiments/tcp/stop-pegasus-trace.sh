#!/bin/bash
sudo kill -USR2 $1 &> /dev/null
sleep 2
sudo docker kill $2 &> /dev/null
sudo kill $1 &> /dev/null
./analyze trace.data
rm -f trace.data
