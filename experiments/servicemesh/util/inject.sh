#!/bin/bash
SCRIPT=`realpath $0`
DIR=`dirname $SCRIPT`
istioctl kube-inject -f $1 | python3 $DIR/modify_istio.py /dev/stdin

