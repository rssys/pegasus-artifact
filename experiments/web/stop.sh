#!/bin/bash
kubectl delete pod/web
kubectl delete service/web
sudo pkill -x runpc
sudo pkill -x pegasus
sleep 2
