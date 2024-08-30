#!/bin/bash
HOST=$1
DIR=$2
mkdir -p $DIR
for N in {1..10}
do
for C in {1,2,4,8,16,24,32,40,48}
do
	echo "N: $N C: $C"
	sudo timeout 30 docker run --rm --runtime pegasus pdlan/pegasus-artifact-bombardier -c $C --insecure -d 20s https://$HOST/test_file -l -o json -p r | tee $DIR/$N-$C.json
	echo
done
done

