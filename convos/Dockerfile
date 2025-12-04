# 1. Recibe el argumento inyectado desde config.yaml (ahora Debian)
ARG BUILD_FROM

# 2. Usa la variable para definir la imagen base
FROM ${BUILD_FROM}

# Instalamos Perl, sus utilidades (cpanminus) y las librerías necesarias
# para compilar módulos (build-essential, libssl-dev, etc.) usando APT.
# Usamos App::Convos para el nombre correcto.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        build-essential \
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
