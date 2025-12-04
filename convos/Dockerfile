# ----------------------------------------------------------------------------------
# ⚠️ CAMBIO CRUCIAL: Usamos la sintaxis nativa de Home Assistant para sustituir
# la arquitectura y forzar el uso de la imagen base de Debian-Build.
# ----------------------------------------------------------------------------------
FROM ghcr.io/home-assistant/%%BUILD_ARCH%%-base-debian-build:latest

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
        cpanminus \
    # Limpieza de caché de APT
    && rm -rf /var/lib/apt/lists/* \
    # Instalamos Convos con cpanminus usando el nombre correcto: App::Convos
    && cpanm --notest App::Convos \
    # Limpieza final de CPAN
    && rm -rf /root/.cpanm /root/.cpan
    
# Puerto por defecto de Convos
EXPOSE 8080

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]
