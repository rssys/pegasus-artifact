#!/bin/bash
g++ 1.cc -O3 -I${PEGASUS_ROOT}/ext/f-stack/lib ${PEGASUS_ROOT}/ext/f-stack/lib/libfstack.a  $(pkg-config --cflags --libs --static libdpdk) -o 1
g++ 2.cc -O3 -o 2
g++ 3.cc -O3 -o 3 -ldemikernel
g++ 4.cc -O3 -o 4
g++ analyze.cc -O3 -o analyze
