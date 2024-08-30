#!/bin/bash
DIR=data/baseline
mkdir -p $DIR
for N in {1..10}
do
    START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-baseline.sh"
    OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
    STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-baseline.sh $OUTPUT"
    sleep 5
    sudo docker run --rm --network host --security-opt seccomp=unconfined pdlan/pegasus-artifact-tcp $PEGASUS_IP_SERVER > $DIR/$N.txt
    ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
done
