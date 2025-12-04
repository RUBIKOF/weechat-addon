ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar ZNC usando apk (Alpine Linux)
RUN \
    apk add --no-cache \
        znc \
        znc-extra

# Copiar el script de inicio
COPY run.sh /
RUN chmod +x /run.sh

# Puertos
EXPOSE 6667 8888

CMD [ "/run.sh" ]
