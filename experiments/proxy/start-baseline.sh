#!/bin/bash
kubectl create -f proxy.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s pod/proxy &> /dev/null
kubectl expose pod proxy --type=LoadBalancer --port=443 &> /dev/null
sleep 5
kubectl get service proxy -o jsonpath='{.spec.ports[*].nodePort}'
