# 1. Recibe el argumento inyectado desde config.yaml
ARG BUILD_FROM

# 2. Usa la variable para definir la imagen base
FROM ${BUILD_FROM}

# Instalamos Perl, sus utilidades (cpanminus) y las librerías necesarias
# para compilar módulos (build-base, openssl-dev, etc.) usando APK.
RUN apk update && \
    apk add --no-cache \
        perl \
        perl-dev \
        build-base \
        openssl-dev \
        postgresql-dev \
        ca-certificates \
        curl \
        jq \
        perl-app-cpanminus \
    # Instalamos Convos con cpanminus usando el nombre correcto: App::Convos
    && cpanm --notest App::Convos \
    # Limpieza
    && rm -rf /var/cache/apk/* /root/.cpanm /root/.cpan

# Puerto por defecto de Convos
EXPOSE 8080

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Comando de inicio del Add-on
CMD [ "/usr/bin/run.sh" ]
