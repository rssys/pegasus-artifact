FROM debian:bookworm AS build

RUN apt-get update && apt-get install -y build-essential libhiredis-dev

WORKDIR /
COPY client.cc /
RUN g++ client.cc -o client -O3 -lhiredis

FROM debian:bookworm-slim

COPY --from=build /client /
WORKDIR /
RUN apt-get update && apt-get install -y libhiredis0.14 && rm -rf /var/cache/apt/archives /var/lib/apt/lists
