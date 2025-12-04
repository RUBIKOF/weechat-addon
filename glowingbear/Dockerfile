FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instalar Node.js, npm, git y utilidades básicas
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        git \
        jq \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clonar el repositorio de Glowing Bear
RUN git clone https://github.com/glowing-bear/glowing-bear.git /usr/src/glowing_bear

# Instalar las dependencias de Node.js
WORKDIR /usr/src/glowing_bear
RUN npm install

# Copiar el script de ejecución del addon
COPY run.sh /run.sh

RUN chmod +x /run.sh

# El cliente web Glowing Bear se ejecuta por defecto en el puerto 3000
EXPOSE 3000

CMD ["/run.sh"]
