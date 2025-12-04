FROM nginx:alpine

# Instalar dependencias para descargar y configurar
RUN apk add --no-cache curl jq

# Descargar Kiwi IRC
RUN curl -L -o /tmp/kiwiirc.tar.gz \
    https://github.com/kiwiirc/kiwiirc/releases/download/v2.1.0/kiwiirc.tar.gz \
    && tar -xzf /tmp/kiwiirc.tar.gz -C /tmp \
    && mv /tmp/kiwiirc-* /usr/share/nginx/html \
    && rm /tmp/kiwiirc.tar.gz

# Copiar configuración personalizada
COPY config.json /usr/share/nginx/html/config.json
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY run.sh /run.sh

RUN chmod +x /run.sh

EXPOSE 8080

CMD ["/run.sh"]
