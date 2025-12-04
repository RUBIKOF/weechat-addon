FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        nginx \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Descargar y EXTRAER manualmente el .deb
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
    # Extraer solo los archivos, sin instalar
    dpkg-deb -x /tmp/kiwiirc.deb /tmp/kiwiirc-extract && \
    # Mover los archivos a donde deben ir
    mv /tmp/kiwiirc-extract/usr/share/kiwiirc /var/www/html && \
    rm -rf /tmp/kiwiirc.deb /tmp/kiwiirc-extract

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
