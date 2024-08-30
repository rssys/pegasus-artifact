FROM debian:bookworm AS build

RUN apt-get update && apt-get install -y build-essential libcpp-httplib-dev

WORKDIR /
COPY client.cc /
RUN g++ client.cc -o client -O3 -lcpp-httplib

FROM debian:bookworm-slim

COPY --from=build /client /
WORKDIR /
RUN apt-get update && apt-get install -y libcpp-httplib0.11 && rm -rf /var/cache/apt/archives /var/lib/apt/lists
