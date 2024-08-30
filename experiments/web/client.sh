#!/bin/bash
HOST=$1
DIR=$2
mkdir -p $DIR
for N in {1..10}
do
	for C in {1,2,3,4,5,10,15,20,25,30,35,40,45,50}
	do
		echo "N: $N C: $C"
		timeout 30 ./bombardier -d 20s --insecure -c $C -p r -l -o j https://$HOST/set/test | tee $DIR/$N-$C.json
		echo
	done
done

