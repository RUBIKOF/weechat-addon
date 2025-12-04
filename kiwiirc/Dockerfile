# Forzamos explícitamente la base Debian de Home Assistant
ARG BUILD_FROM=ghcr.io/home-assistant/{ARCH}-base-debian:latest
FROM ${BUILD_FROM}

# Evitamos prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Paquetes base: node, npm, git, certificados, etc.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      nodejs \
      npm \
      tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Directorio donde clonaremos KiwiIRC
ENV KIWIIRC_HOME=/opt/kiwiirc

# Clonamos KiwiIRC desde GitHub y instalamos dependencias
RUN git clone https://github.com/kiwiirc/kiwiirc.git ${KIWIIRC_HOME} && \
    cd ${KIWIIRC_HOME} && \
    npm install --production

# Puerto por donde exponemos KiwiIRC
EXPOSE 7778

# Script de arranque del add-on
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD [ "/usr/bin/run.sh" ]
