# Usa una imagen base de Alpine de Home Assistant
# En un Add-on real de HA, esta línea a menudo se define con un ARG
# Si usaste un ARG BUILD_FROM antes, aquí puedes usarlo,
# pero para ser directos usamos una base común.

# Si tu base es 'ghcr.io/home-assistant/aarch64-base:latest'
# simplemente usa esa imagen aquí.

FROM ghcr.io/home-assistant/{ARCH}-base:latest

# Instalamos Perl, sus utilidades (cpanminus) y las librerías necesarias
# para compilar módulos (build-base, libssl-dev, etc.) usando APK.
# El comando RUN se hace en una sola capa para ser eficiente.

RUN apk update && \
    apk add --no-cache \
        perl \
        perl-dev \
        build-base \
        libssl-dev \
        libpq-dev \
        ca-certificates \
        curl \
        jq \
        perl-app-cpanminus \
    # Instalamos Convos con cpanminus y lo marcamos para no hacer pruebas (--notest)
    && cpanm --notest Convos \
    # Limpieza para reducir el tamaño final de la imagen
    && rm -rf /var/cache/apk/* /root/.cpanm /root/.cpan

# Puerto por defecto de Convos
EXPOSE 8080

# Copiar el script de inicio (run.sh)
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]
