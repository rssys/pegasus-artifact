#!/bin/bash
kubectl create -f http-istio.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s pod/http &> /dev/null
kubectl expose pod http --type=LoadBalancer --port=80 &> /dev/null
sleep 5
kubectl get service http -o jsonpath='{.spec.ports[*].nodePort}'
