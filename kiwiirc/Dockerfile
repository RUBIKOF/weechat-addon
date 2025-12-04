# Imagen base LIMPIA, sin s6, sin HA: solo Alpine
FROM alpine:3.20

# Evitar prompts innecesarios
ENV TERM=xterm

# Instalar dependencias con apk (Alpine)
RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    tzdata

# Directorio de instalación de KiwiIRC
ENV KIWIIRC_HOME=/opt/kiwiirc

# Clonar KiwiIRC desde GitHub (shallow clone para hacerlo más ligero)
RUN git clone --depth=1 https://github.com/kiwiirc/kiwiirc.git ${KIWIIRC_HOME}

# Instalar dependencias de Node
RUN cd ${KIWIIRC_HOME} && npm install --production

# Puerto donde KiwiIRC escuchará
EXPOSE 7778

# Copiar script de arranque del add-on
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD [ "/usr/bin/run.sh" ]
