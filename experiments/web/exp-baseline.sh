#!/bin/bash
START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/web && ./start-baseline.sh"
PORT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/web && ./stop-baseline.sh"
sleep 10
./client.sh $PEGASUS_IP_SERVER:$PORT data/baseline
ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
