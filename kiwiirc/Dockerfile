FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        nginx \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Solo amd64 por ahora
RUN wget -O /tmp/kiwiirc.deb \
    "https://kiwiirc.com/downloads/kiwiirc_20.05.24.1-1_amd64.deb" && \
    dpkg-deb -x /tmp/kiwiirc.deb /tmp/kiwiirc-extract && \
    mv /tmp/kiwiirc-extract/usr/share/kiwiirc /var/www/html && \
    rm -rf /tmp/kiwiirc.deb /tmp/kiwiirc-extract

EXPOSE 8080

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
