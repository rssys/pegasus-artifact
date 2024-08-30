#!/bin/bash
DIR=$1
YAML=$2
mkdir -p $DIR
for N in {1..10}
do
	kubectl delete job.batch/http
	kubectl apply -f $YAML
	kubectl wait --for=condition=complete --timeout=60s job.batch/http
	kubectl logs job.batch/http -c client |tee $DIR/$N.txt
	kubectl delete job.batch/http
done
