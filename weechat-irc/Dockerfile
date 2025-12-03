FROM alpine:latest

# Instala las dependencias necesarias (jq para JSON, weechat, y python)
RUN apk update && \
    apk add --no-cache jq weechat python3 py3-pip && \
    rm -rf /var/cache/apk/*

# Copia el script de ejecución
COPY run.sh /
# Crea la carpeta de configuración para WeeChat
RUN mkdir -p /root/.weechat

# Asegúrate de que el script de ejecución sea ejecutable
RUN chmod a+x /run.sh

EXPOSE 8000

# Define el punto de entrada del addon
CMD [ "/run.sh" ]
