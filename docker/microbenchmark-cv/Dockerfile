FROM debian:bookworm AS build

RUN apt-get update && apt-get install -y build-essential

WORKDIR /
COPY cv.cc /
RUN g++ cv.cc -o cv -O3

FROM debian:bookworm-slim
COPY --from=build /cv /
