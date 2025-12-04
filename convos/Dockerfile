# Define la variable de arquitectura.
ARG BUILD_FROM

# ⚠️ FORZAMOS la imagen base de Debian-Build con un valor predeterminado 
#    para que funcione si el Supervisor falla al inyectar BUILD_FROM.
FROM ${BUILD_FROM:-ghcr.io/home-assistant/aarch64-base-debian-build:latest}

# Instalamos Perl, sus utilidades (cpanminus) y las librerías necesarias.
# build-essential ya está incluido en la imagen base.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        libssl-dev \
        libpq-dev \
        ca-certificates \
        curl \
        jq \
        cpanminus && \
    # Limpieza de caché de APT
    rm -rf /var/lib/apt/lists/* && \
    # Instalamos Convos con cpanminus usando el nombre correcto: App::Convos
    cpanm --notest App::Convos && \
    # Limpieza final de CPAN
    rm -rf /root/.cpanm /root/.cpan
    
# Puerto por defecto de Convos
EXPOSE 8080

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]
