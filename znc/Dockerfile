ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar solo ZNC
RUN apk add --no-cache znc

# Copiar script
COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 6667 8888

CMD [ "/run.sh" ]
