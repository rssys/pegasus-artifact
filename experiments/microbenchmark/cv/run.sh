#!/bin/bash
DIR=$1
YAML=$2
mkdir -p $DIR
for N in {1..10}
do
	for I in {1..10}
	do
		kubectl delete job.batch/cv
		kubectl apply -f $YAML
		kubectl wait --for=condition=complete --timeout=30s job.batch/cv
		kubectl logs job.batch/cv |tee $DIR/$N.txt
		kubectl delete job.batch/cv
		if python3 check.py $DIR/$N.txt
		then
			break
		fi
	done
done
