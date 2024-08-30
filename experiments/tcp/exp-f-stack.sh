#!/bin/bash
DIR=data/f-stack
mkdir -p $DIR
cat config-fstack.ini.in | sed -e "s/CONFIG_IP/$PEGASUS_IP_CLIENT/g" | sed -e "s/CONFIG_PCI/$PEGASUS_PCI_CLIENT/g" > config-fstack.ini
for N in {1..10}
do
    START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-fstack.sh"
    OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
    STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-fstack.sh $OUTPUT"
    sleep 5
    script -q -c  "sudo timeout 30 ./1 $PEGASUS_IP_SERVER --conf config-fstack.ini" $DIR/$N.txt
    ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
done
