# Usamos una imagen base pública y ligera de Alpine para evitar el error 403
FROM alpine:latest

# Instala las dependencias necesarias: jq para parsear JSON, weechat, y dependencias para Python
RUN apk update && \
    apk add --no-cache jq weechat python3 py3-pip && \
    rm -rf /var/cache/apk/*

# Copia el script de ejecución
COPY run.sh /
# Crea la carpeta de configuración para WeeChat
RUN mkdir -p /root/.weechat

# Asegúrate de que el script de ejecución sea ejecutable
RUN chmod a+x /run.sh

# El addon expondrá este puerto (pero es el 'ports' en config.json el que importa)
EXPOSE 8000

# Define el punto de entrada del addon
CMD [ "/run.sh" ]
