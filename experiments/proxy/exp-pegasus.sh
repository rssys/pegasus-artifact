#!/bin/bash
OPT=$1
START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/proxy && ./start.sh $OPT"
PORT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/proxy && ./stop.sh"
setsid ./start_pegasus.sh > /dev/null 2>&1 &
PID_PEGASUS=$!
sleep 10
./client.sh $PEGASUS_IP_SERVER:$PORT data/pegasus-$OPT
ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
kill $PID_PEGASUS
../kill-pegasus.sh
