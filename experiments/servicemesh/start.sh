#!/bin/bash
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
kubectl create -f http-istio-runpc.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s web/http &> /dev/null
kubectl expose pod http --type=LoadBalancer --port=80 &> /dev/null
sleep 5
kubectl get service http -o jsonpath='{.spec.ports[*].nodePort}'
