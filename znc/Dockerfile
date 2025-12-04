# Define la variable de arquitectura.
ARG BUILD_FROM

# ⚠️ Forzamos la base de Debian-Slim para estabilidad máxima (como en tu Add-on de WeeChat)
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
    
# Puerto por defecto de ZNC (Web y Bouncer)
EXPOSE 6667

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]

