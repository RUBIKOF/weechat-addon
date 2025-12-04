FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        nginx \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        KIWI_URL="https://kiwiirc.com/downloads/kiwiirc_20.05.24.1-1_amd64.deb"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        KIWI_URL="https://kiwiirc.com/downloads/kiwiirc_20.05.24.1-1_arm64.deb"; \
    elif [ "$TARGETARCH" = "armhf" ]; then \
        KIWI_URL="https://kiwiirc.com/downloads/kiwiirc_20.05.24.1-1_armhf.deb"; \
    else \
        echo "Arquitectura no soportada: $TARGETARCH" && exit 1; \
    fi && \
    wget -O /tmp/kiwiirc.deb "$KIWI_URL" && \
    dpkg-deb -x /tmp/kiwiirc.deb /tmp/kiwiirc-extract && \
    mv /tmp/kiwiirc-extract/usr/share/kiwiirc /var/www/html && \
    rm -rf /tmp/kiwiirc.deb /tmp/kiwiirc-extract

EXPOSE 8080

# USAR init: false en config.yaml y evitar s6
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
