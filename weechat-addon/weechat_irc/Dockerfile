# Usa una imagen base robusta con paquetes (ej. Alpine Linux)
FROM ghcr.io/home-assistant/base-aarch64:stable 

# O si tu Home Assistant no es aarch64, ajusta la arquitectura (amd64, armv7)
# FROM ghcr.io/home-assistant/base-amd64:stable

# Instala 'jq' para parsear JSON y 'weechat'
# Usamos 'apk' si la base es Alpine, o 'apt' si es Debian-based. La imagen base de HA usa Alpine.
RUN apk update && \
    apk add --no-cache jq weechat && \
    rm -rf /var/cache/apk/*

# Copia el script de ejecución
COPY run.sh /
# Copia la configuración (si tienes alguna inicial)
# COPY files/weechat.conf /root/.weechat/weechat.conf

# Crea la carpeta de configuración para WeeChat
RUN mkdir -p /root/.weechat

# Asegúrate de que el script de ejecución sea ejecutable
RUN chmod a+x /run.sh

# El addon expondrá este puerto para la conexión del relay
EXPOSE 8000

# Define el punto de entrada del addon
CMD [ "/run.sh" ]
