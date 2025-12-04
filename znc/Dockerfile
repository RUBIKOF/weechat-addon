ARG BUILD_FROM

FROM $BUILD_FROM

# Instalar ZNC con soporte completo
RUN apk add --no-cache \
    znc \
    znc-extra \
    su-exec \
    tini

# Crear usuario znc
RUN adduser -S znc

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Puertos de ZNC
EXPOSE 6667 8888

# Usar tini como init para mejor manejo de señales
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/run.sh"]
