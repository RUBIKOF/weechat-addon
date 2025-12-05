# Dockerfile para ZNC con módulos completos (incluyendo clientaway)
# Adaptado a la imagen base de Home Assistant (Alpine)

ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV ZNC_VERSION=1.9.1

# 1. Paquetes necesarios para compilar y ejecutar ZNC (en Alpine)
RUN apk add --no-cache \
        ca-certificates \
        curl \
        build-base \
        cmake \
        pkgconfig \
        openssl-dev \
        icu-dev \
        perl-dev \
        python3 \
        autoconf \
        automake \
        libtool && \
    update-ca-certificates

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

# 4. Script de arranque
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# 5. Comando por defecto
CMD ["/usr/bin/run.sh"]
