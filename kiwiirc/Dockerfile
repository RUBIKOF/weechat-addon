FROM debian:stable-slim

# 1. Instalar dependencias para construir
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        python3 \
        make \
        g++ \
        ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Clonar y construir Kiwi IRC v1.7.1 (estable)
RUN git clone --branch v1.7.1 --depth 1 \
    https://github.com/kiwiirc/kiwiirc.git /app && \
    cd /app && \
    npm install && \
    npm run build

# 3. Instalar nginx para servir
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. Mover archivos construidos
RUN mv /app/dist /var/www/html && \
    rm -rf /app

EXPOSE 8080

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
