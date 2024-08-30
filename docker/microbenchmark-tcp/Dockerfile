FROM debian:bookworm AS build

RUN apt-get update && apt-get install -y build-essential

WORKDIR /
COPY client.cc /
COPY server.cc /
RUN g++ client.cc -o client -O3 && g++ server.cc -o server -O3

FROM debian:bookworm-slim
COPY --from=build /server /
COPY --from=build /client /
