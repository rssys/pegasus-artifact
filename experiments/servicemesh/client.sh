#!/bin/bash
HOST=$1
DIR=$2
mkdir -p $DIR
for N in {1..10}
do
	for C in {2,4,6,8,10,20,40,60,80,100,120,140,160,180,200}
	do
		echo "N: $N C: $C"
		timeout 30 ./bombardier -d 20s --insecure -c $C -p r -l -o j http://$HOST/hello | tee $DIR/$N-$C.json
		echo
	done
done

