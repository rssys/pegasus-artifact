#!/bin/bash
DIR=$1
mkdir -p $DIR
C=(1 1 1 1 2 4 6 8 10 12 14 16)
T=(1 2 3 4 4 4 4 4 4  4  4  4)
for N in {1..10}
do
for I in {0..11}
do
for J in {1..10}
do
	echo "C: ${C[$I]} T: ${T[$I]}"
	sudo docker run --rm --runtime pegasus -v `realpath $DIR`:/data pdlan/pegasus-artifact-memtier_benchmark -h $PEGASUS_IP_SERVER -c ${C[$I]} -t ${T[$I]} --test-time=20 --json-out-file /data/$N-$I.json
	if python3 check.py $DIR/$N-$I.json
	then
		break
	fi
done
done
done

