#!/bin/bash
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
kubectl create -f web-runpc.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s web/proxy &> /dev/null
kubectl expose pod web --type=LoadBalancer --port=443 &> /dev/null
sleep 5
kubectl get service web -o jsonpath='{.spec.ports[*].nodePort}'
