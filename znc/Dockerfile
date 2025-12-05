ARG BUILD_FROM
FROM ${BUILD_FROM}

# El base de Home Assistant ya es Alpine, así que usamos apk
RUN apk add --no-cache \
    znc \
    ca-certificates \
    curl && \
    update-ca-certificates

# Carpeta de datos (mapeada a /config/znc por el add-on)
RUN mkdir -p /config/znc

COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD ["/usr/bin/run.sh"]
