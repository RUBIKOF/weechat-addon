# Define la variable de arquitectura.
ARG BUILD_FROM

# Usamos la base de Debian-Slim para la instalación de ZNC con apt-get
FROM debian:stable-slim

# Instalamos ZNC y las herramientas esenciales.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        znc \
        ca-certificates \
        jq \
        curl && \
    # Limpieza de caché
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Puertos de ZNC: 6667 para IRC, 8888 para la Interfaz Web.
EXPOSE 6667
EXPOSE 8888

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]
