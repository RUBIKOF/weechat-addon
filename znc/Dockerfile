# Dockerfile para ZNC con módulos completos (incluyendo clientaway)

ARG BUILD_FROM=debian:stable-slim
FROM ${BUILD_FROM}

ENV DEBIAN_FRONTEND=noninteractive
ENV ZNC_VERSION=1.9.1

# 1. Paquetes necesarios para compilar y ejecutar ZNC
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        build-essential \
        cmake \
        pkg-config \
        libssl-dev \
        libicu-dev \
        libperl-dev \
        python3 && \
    rm -rf /var/lib/apt/lists/*

# 2. Descargar y compilar ZNC desde el código fuente
RUN mkdir -p /tmp/znc-build && \
    cd /tmp/znc-build && \
    curl -L "https://znc.in/releases/znc-${ZNC_VERSION}.tar.gz" -o znc.tar.gz && \
    tar xzf znc.tar.gz && \
    cd "znc-${ZNC_VERSION}" && \
    ./configure --prefix=/usr && \
    make -j"$(nproc)" && \
    make install && \
    cd / && \
    rm -rf /tmp/znc-build

# 3. Puertos que expondrá el contenedor
EXPOSE 6667 8888

# 4. Script de arranque (ya lo tienes creado)
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# 5. Comando por defecto
CMD ["/usr/bin/run.sh"]
