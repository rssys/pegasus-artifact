#!/bin/bash
cd cv
./run.sh data/baseline cv.yaml
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
./run.sh data/pegasus cv-runpc.yaml
kill $PID
cd ..
cd tcp
./run.sh data/baseline tcp.yaml
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
./run.sh data/pegasus tcp-runpc.yaml
kill $PID
cd ..
cd redis
./run.sh data/baseline redis.yaml
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
./run.sh data/pegasus redis-runpc.yaml
kill $PID
cd ..
cd memcached
./run.sh data/baseline memcached.yaml
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
./run.sh data/pegasus memcached-runpc.yaml
kill $PID
cd ..
cd http
./run.sh data/baseline http.yaml
setsid sudo pegasus pegasus.conf > /dev/null 2>&1 &
PID=$!
sleep 5
./run.sh data/pegasus http-runpc.yaml
kill $PID
cd ..



