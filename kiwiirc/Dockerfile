# Home Assistant FORZARÁ Alpine, así que nos ajustamos a Alpine
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Evitar prompts
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias con apk (Alpine)
RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    tzdata

# Directorio de instalación
ENV KIWIIRC_HOME=/opt/kiwiirc

# Clonar KiwiIRC
RUN git clone --depth=1 https://github.com/kiwiirc/kiwiirc.git ${KIWIIRC_HOME}

# Instalar dependencias de Node
RUN cd ${KIWIIRC_HOME} && npm install --production

# Puerto
EXPOSE 7778

# Copiar script de arranque
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD [ "/usr/bin/run.sh" ]
