ARG BUILD_FROM
FROM ${BUILD_FROM}

# Instalar nginx en la imagen base de HA
RUN apk add --no-cache nginx

# Descargar Kiwi IRC
RUN wget -O /tmp/kiwi.tar.gz https://github.com/kiwiirc/kiwiirc/releases/download/v2.1.0/kiwiirc.tar.gz \
    && tar -xzf /tmp/kiwi.tar.gz -C /var/www \
    && rm /tmp/kiwi.tar.gz \
    && mv /var/www/kiwiirc-* /var/www/kiwiirc

# Copiar configuración nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Script de inicio simple
COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 8080

CMD [ "/run.sh" ]
