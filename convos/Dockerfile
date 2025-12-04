# Usa una imagen base de Alpine con las dependencias necesarias.
# Convos necesita Perl, su gestor de paquetes (cpanminus) y otras librerías.
FROM alpine:3.18

# Instalar dependencias necesarias para Convos (Perl, SSL, etc.)
RUN apk add --no-cache \
    perl \
    perl-cpanminus \
    perl-app-cpanminus \
    perl-mojolicious \
    perl-crypt-ssleay \
    perl-json-xs \
    perl-io-socket-ssl \
    build-base \
    libxml2-dev \
    libxslt-dev \
    libmaxminddb-dev

# Crear un directorio de trabajo y un usuario no-root por seguridad
WORKDIR /app
RUN adduser -D -u 1000 appuser
USER appuser

# Instalar Convos usando cpanminus
RUN cpanm Convos

# Copiar el script de inicio
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Puerto por defecto de Convos
EXPOSE 8080

# Comando de inicio
CMD [ "/usr/bin/run.sh" ]
