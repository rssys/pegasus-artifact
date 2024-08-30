#!/bin/bash
OPT=$1
cat pegasus-$OPT.conf.in | sed -e "s=CONFIG_FSTACK=$PEGASUS_ROOT/config/config.ini=g" > pegasus.conf
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
kubectl create -f proxy-runpc.yaml &> /dev/null
kubectl wait --all --for=condition=Ready --timeout=300s pod/proxy &> /dev/null
kubectl expose pod proxy --type=LoadBalancer --port=443 &> /dev/null
sleep 5
PORT=`kubectl get service proxy -o jsonpath='{.spec.ports[*].nodePort}'`
if [ "$OPT" == "allopt" ] || [ "$OPT" == "novtcp" ]; then
    PORT=443
fi
echo -n $PORT
