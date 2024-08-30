#!/bin/bash
kubectl create -f web.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s pod/web &> /dev/null
kubectl expose pod web --type=LoadBalancer --port=443 &> /dev/null
sleep 5
kubectl get service web -o jsonpath='{.spec.ports[*].nodePort}'
