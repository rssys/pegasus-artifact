#!/bin/bash
DIR=data/demikernel
mkdir -p $DIR
cat config.yaml.in | sed -e "s/CONFIG_SERVER_IP/$PEGASUS_IP_SERVER/g" | \
    sed -e "s/CONFIG_PCI/$PEGASUS_PCI_SERVER/g" | sed -e "s/CONFIG_CLIENT_IP/$PEGASUS_IP_CLIENT/g" | \
    sed -e "s/CONFIG_SERVER_MAC/$PEGASUS_MAC_SERVER/g" | sed -e "s/CONFIG_CLIENT_MAC/$PEGASUS_MAC_CLIENT/g" > config.yaml
for N in {1..10}
do
    START_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./start-demikernel.sh"
    OUTPUT=`ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$START_CMD\""`
    STOP_CMD="source $PEGASUS_ROOT/env.sh && cd $PEGASUS_ROOT/experiments/tcp && ./stop-demikernel.sh $OUTPUT"
    sleep 5
    sudo env MSS=1500 MTU=1500 LIBOS=catnip CONFIG_PATH=config.yaml ./3 --client $PEGASUS_IP_SERVER 8000 > $DIR/$N.txt
    ssh $PEGASUS_IP_SERVER_CONTROL bash -c "\"$STOP_CMD\""
    sleep 5
done
