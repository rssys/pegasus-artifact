#!/bin/bash
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
kubectl create -f local-proxy-runpc.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s pod/local-proxy &> /dev/null
kubectl expose pod local-proxy --type=LoadBalancer --port=80 &> /dev/null
sleep 5
kubectl get service local-proxy -o jsonpath='{.spec.ports[*].nodePort}'
