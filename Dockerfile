FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends keepalived dnsutils curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/keepalived.tar.gz https://github.com/gen2brain/keepalived_exporter/releases/download/v0.7.1/keepalived_exporter-0.7.1-amd64.tar.gz && \
    tar --strip-components=1 -xzf /tmp/keepalived.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/keepalived_exporter && \
    rm /tmp/keepalived.tar.gz

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]