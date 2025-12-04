FROM debian:stable-slim

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        nginx \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Descargar e instalar Kiwi IRC para la arquitectura correspondiente
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
    dpkg -i /tmp/kiwiirc.deb || apt-get install -f -y && \
    rm /tmp/kiwiirc.deb

# Enlazar Kiwi IRC al directorio web de nginx
RUN rm -rf /var/www/html && \
    ln -s /usr/share/kiwiirc /var/www/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
