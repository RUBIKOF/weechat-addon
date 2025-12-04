ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar Node.js y dependencias
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    python3 \
    make \
    g++

# Clonar y construir Kiwi IRC
WORKDIR /app
RUN git clone https://github.com/kiwiirc/kiwiirc.git . && \
    npm install && \
    npm run build && \
    npm install -g serve

# Copiar script de inicio
COPY run.sh /
RUN chmod +x /run.sh

# Puerto de Kiwi IRC
EXPOSE 8080

CMD [ "/run.sh" ]
