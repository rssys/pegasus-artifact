FROM debian:bookworm AS build

RUN apt-get update && apt-get install -y build-essential

WORKDIR /
COPY 2.cc /
COPY 4.cc /
RUN g++ 2.cc -O3 -o /usr/local/bin/tcp && gcc 4.cc -O3 -o /usr/local/bin/tcp-trace

FROM debian:bookworm-slim
COPY --from=build /usr/local/bin/tcp /usr/local/bin/
COPY --from=build /usr/local/bin/tcp-trace /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/tcp"]
