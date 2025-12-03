FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        weechat-headless \
        weechat-plugins \
        jq \
        ca-certificates \
        python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh

RUN mkdir -p /root/.weechat && \
    chmod +x /run.sh

EXPOSE 8000

CMD ["/run.sh"]
