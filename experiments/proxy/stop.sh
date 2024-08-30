#!/bin/bash
kubectl delete pod/proxy
kubectl delete service/proxy
sudo pkill -x runpc
sudo pkill -x pegasus
sleep 2
