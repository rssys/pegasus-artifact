#!/bin/bash
sudo docker kill $1 --signal=SIGKILL
