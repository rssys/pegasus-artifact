#!/bin/bash
START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/redis/pegasus && ./start.sh"
OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/redis/pegasus && ./stop.sh $OUTPUT"
setsid ./start_pegasus.sh > /dev/null 2>&1 &
PID_PEGASUS=$!
sleep 10
./client.sh data/pegasus
ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
kill $PID_PEGASUS
../kill-pegasus.sh
