FROM golang:1.21.4 AS build

RUN cd /root && \
    git clone https://github.com/caddyserver/caddy -b v2.7.5 && \
    cd caddy/cmd/caddy && \
    GO111MODULE=on go build -buildmode=pie && \
    cp caddy /usr/local/bin && \
    cd ~ && \
    rm -rf /root/caddy

FROM debian:bookworm-slim
COPY --from=build /usr/local/bin/caddy /usr/local/bin/
COPY test_file /root/

ENTRYPOINT ["/usr/local/bin/caddy", "file-server", "--root", "/root", "--listen", ":8080"]
