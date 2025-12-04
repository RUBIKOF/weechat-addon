ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar ZNC y crear usuario
RUN \
    apk add --no-cache \
        znc \
        znc-extra \
    && adduser -D -H -h /var/lib/znc -s /bin/false znc

# Copiar el script de inicio
COPY run.sh /
RUN chmod +x /run.sh

# Configurar s6 para correr como usuario znc
ENV S6_UIDGID=1000:1000

# Puertos
EXPOSE 6667 8888

CMD [ "/run.sh" ]
