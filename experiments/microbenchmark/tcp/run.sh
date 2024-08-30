#!/bin/bash
DIR=$1
YAML=$2
mkdir -p $DIR
for N in {1..10}
do
	kubectl delete job.batch/tcp
	kubectl apply -f $YAML
	kubectl wait --for=condition=complete --timeout=30s job.batch/tcp
	kubectl logs job.batch/tcp -c client > $DIR/$N.txt
	kubectl delete job.batch/tcp
done
