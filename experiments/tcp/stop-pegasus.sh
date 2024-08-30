#!/bin/bash
sudo docker kill $2 &> /dev/null
sudo kill $1 &> /dev/null
