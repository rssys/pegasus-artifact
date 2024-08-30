#!/bin/bash
DIR=data/pegasus-trace
mkdir -p $DIR
START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-pegasus-trace.sh"
OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-pegasus-trace.sh $OUTPUT"
setsid ./start_pegasus.sh > /dev/null 2>&1 &
PID_PEGASUS=$!
sleep 5
sudo docker run --rm --runtime pegasus --network host --security-opt seccomp=unconfined pdlan/pegasus-artifact-tcp $PEGASUS_IP_SERVER > $DIR/res.txt
ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\"" > $DIR/analyze.txt
kill $PID_PEGASUS
../kill-pegasus.sh
