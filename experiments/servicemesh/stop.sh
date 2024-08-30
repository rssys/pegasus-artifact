#!/bin/bash
kubectl delete pod/http --force
kubectl delete service/http
sudo pkill -x runpc
sudo pkill -x pegasus
sleep 2
