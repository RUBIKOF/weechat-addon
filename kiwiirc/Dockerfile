ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar nginx (sin Node.js para simplificar - usaremos build previo)
RUN apk add --no-cache nginx

# Crear directorio para Kiwi IRC
WORKDIR /var/www

# Descargar Kiwi IRC ya construido (más rápido que construir)
RUN wget -O kiwiirc.tar.gz https://github.com/kiwiirc/kiwiirc/releases/download/v2.1.0/kiwiirc.tar.gz && \
    tar -xzf kiwiirc.tar.gz && \
    rm kiwiirc.tar.gz && \
    mv kiwiirc-* kiwiirc

# Configurar nginx
COPY nginx.conf /etc/nginx/http.d/kiwiirc.conf

# Script de inicio para s6
RUN mkdir -p /etc/services.d/nginx
COPY s6-nginx-run /etc/services.d/nginx/run
RUN chmod +x /etc/services.d/nginx/run

# Puerto
EXPOSE 8080

# Usar init de s6
CMD ["/init"]
