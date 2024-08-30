FROM debian:bookworm

RUN apt-get update \
    && apt-get install nodejs npm curl --no-install-recommends -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app
COPY package.json /opt/app
COPY main.js /opt/app
RUN npm install

EXPOSE 8080
ENTRYPOINT ["/usr/bin/node", "/opt/app/main.js", "8080"]

USER 1000
