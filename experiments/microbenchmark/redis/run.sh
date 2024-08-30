#!/bin/bash
DIR=$1
YAML=$2
mkdir -p $DIR
for N in {1..10}
do
	kubectl delete job.batch/redis
	kubectl apply -f $YAML
	kubectl wait --for=condition=complete --timeout=30s job.batch/redis
	kubectl logs job.batch/redis -c client |tee $DIR/$N.txt
	kubectl delete job.batch/redis
done
