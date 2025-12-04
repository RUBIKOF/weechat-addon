ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar nginx
RUN apk add --no-cache nginx

# Descargar Kiwi IRC precompilado
RUN wget -O /tmp/kiwi.tar.gz https://github.com/kiwiirc/kiwiirc/releases/download/v2.1.0/kiwiirc.tar.gz && \
    tar -xzf /tmp/kiwi.tar.gz -C /var/www && \
    rm /tmp/kiwi.tar.gz

# Copiar configuración nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
