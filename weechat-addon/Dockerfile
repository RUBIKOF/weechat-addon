# Usa una imagen base de Home Assistant que tenga Python
# Se recomienda usar la imagen base oficial de HA para addons
FROM ghcr.io/home-assistant/base-aarch64:stable

# O si tu Home Assistant no es aarch64, ajusta la arquitectura:
# FROM ghcr.io/home-assistant/base-amd64:stable 

# Instala Python 3 y pip
RUN apk add --no-cache python3 py3-pip

# Copia el script de ejecución y el código del bridge
COPY run.sh /
COPY weechat_bridge.py /app/

# Instala las dependencias de Python
# Necesitas una librería para el protocolo de relay de WeeChat (puedes buscar una o usar sockets)
# Y la librería paho-mqtt para la comunicación con HA
RUN pip3 install paho-mqtt

# Asegúrate de que el script sea ejecutable
RUN chmod a+x /run.sh

# Establece el punto de entrada del contenedor
CMD [ "/run.sh" ]
