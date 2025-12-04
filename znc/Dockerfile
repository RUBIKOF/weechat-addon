ARG BUILD_FROM
FROM $BUILD_FROM

# Instalar ZNC con apt (para debian)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        znc \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario znc si no existe
RUN if ! id znc >/dev/null 2>&1; then \
        useradd -r -s /bin/false -d /var/lib/znc znc; \
    fi

# Copiar el script de inicio
COPY run.sh /
RUN chmod +x /run.sh

# Puertos
EXPOSE 6667 8888

CMD ["/run.sh"]
