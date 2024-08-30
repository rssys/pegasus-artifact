#!/bin/bash
DIR=$1
YAML=$2
mkdir -p $DIR
for N in {1..10}
do
	kubectl delete job.batch/memcached
	kubectl apply -f $YAML
	kubectl wait --for=condition=complete --timeout=30s job.batch/memcached
	kubectl logs job.batch/memcached -c client |tee $DIR/$N.txt
	kubectl delete job.batch/memcached
done
