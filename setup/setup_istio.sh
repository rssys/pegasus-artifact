#!/bin/bash
cd $PEGASUS_ROOT
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.0 TARGET_ARCH=x86_64 sh -
cd istio-1.20.0
export PATH=$PWD/bin:$PATH
yes|istioctl install

