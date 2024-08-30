FROM debian:bookworm-slim

RUN apt-get update && apt-get -y install wget && \
    wget https://github.com/RedisLabs/memtier_benchmark/releases/download/2.0.0/memtier-benchmark_2.0.0.bookworm_amd64.deb && \
    apt-get -y install ./memtier-benchmark_2.0.0.bookworm_amd64.deb && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists

ENTRYPOINT ["/usr/bin/memtier_benchmark"]
