FROM golang:1.21.4 AS build
COPY sys_linux_amd64.s /usr/local/go/src/runtime/
COPY asm_linux_amd64.s /usr/local/go/src/runtime/internal/syscall/
RUN /bin/sh -c /bin/sh -c cd /root && \
    git clone https://github.com/codesenberg/bombardier.git -b v1.2.6 && \
    cd bombardier && go build -buildmode=pie && cp bombardier /usr/local/bin && \
    cd /root && rm -rf /root/bombardier
FROM debian:bookworm-slim
COPY --from=build /usr/local/bin/bombardier /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/bombardier"]


