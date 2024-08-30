#!/bin/bash
DIR=data/pegasus
mkdir -p $DIR
for N in {1..10}
do
    START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-pegasus.sh"
    OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
    STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-pegasus.sh $OUTPUT"
    setsid ./start_pegasus.sh > /dev/null 2>&1 &
    PID_PEGASUS=$!
    sleep 5
    sudo docker run --rm --runtime pegasus --network host --security-opt seccomp=unconfined pdlan/pegasus-artifact-tcp $PEGASUS_IP_SERVER > $DIR/$N.txt
    ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
    kill $PID_PEGASUS
    ../kill-pegasus.sh
done
