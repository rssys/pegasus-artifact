#!/bin/bash
DIR=data/demikernel
mkdir -p $DIR
C=(1 1 1 1 2 4 6 8 10 12 14 16 18 20)
T=(1 2 3 4 4 4 4 4 4  4  4  4  4  4)
for N in {1..10}
do
# Demikernel crashes at higher concurrency, so we stop earlier
for I in {0..6}
do
	for J in {1..10}
	do
		echo "C: ${C[$I]} T: ${T[$I]}"
		setsid ./start_pegasus.sh > /dev/null 2>&1 &
		START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/redis/demikernel && ./start.sh"
		OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
		STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/redis/demikernel && ./stop.sh $OUTPUT"
		sleep 10
		CONTAINER=$(sudo docker run --detach --rm --runtime pegasus -v `realpath $DIR`:/data pdlan/pegasus-artifact-memtier_benchmark -h $PEGASUS_IP_SERVER -c ${C[$I]} -t ${T[$I]} --test-time=20 --json-out-file /data/$N-$I.json)
		sleep 30
		sudo docker kill $CONTAINER
		ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
		../kill-pegasus.sh
		sleep 5
		if python3 check.py $DIR/$N-$I.json
		then
			break
		fi
		echo "Retry $J"
	done
done
done
