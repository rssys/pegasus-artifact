#!/bin/bash
kubectl delete pod/local-proxy
kubectl delete service/local-proxy
sudo pkill -x runpc
sudo pkill -x pegasus
sleep 2
