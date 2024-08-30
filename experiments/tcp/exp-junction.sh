#!/bin/bash
DIR=data/junction
mkdir -p $DIR
sed -e "s/CONFIG_IP/$PEGASUS_IP_CLIENT/g" junction.conf.in  > junction.conf
for N in {1..10}
do
    START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-junction.sh"
    OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
    STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-junction.sh $OUTPUT"
    sleep 5
    junction_run junction.conf -- ./2 $PEGASUS_IP_SERVER > $DIR/$N.txt
    ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
done
