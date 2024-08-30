#!/bin/bash
PEGASUS_DOCKER_PREFIX=pdlan/pegasus-artifact
CONTAINERS=("redis" "nginx" "web-nginx" "web-node" "go" "bombardier"
	"local-proxy-nginx"
	"proxy-caddy" "proxy-caddy-pegasus" "openresty-hello"
	"microbenchmark-http-client" "microbenchmark-cv"
	"microbenchmark-memcached" "microbenchmark-redis" "microbenchmark-tcp"
	"tcp" "memtier_benchmark")
for C in ${CONTAINERS[*]}
do
	(cd $C && sudo docker build . -t $PEGASUS_DOCKER_PREFIX-$C --push)
done
