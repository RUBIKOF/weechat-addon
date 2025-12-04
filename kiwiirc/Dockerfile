FROM nginx:alpine

# Instalar wget para descargar
RUN apk add --no-cache wget tar

# Descargar Kiwi IRC v1.7.1 - ¡ESTE ENLACE SÍ EXISTE!
RUN wget -O /tmp/kiwiirc.tar.gz \
    "https://github.com/kiwiirc/kiwiirc/archive/refs/tags/v1.7.1.tar.gz" \
    && tar -xzf /tmp/kiwiirc.tar.gz -C /tmp \
    && ls -la /tmp/ \
    && mv /tmp/kiwiirc-1.7.1 /usr/share/nginx/html \
    && rm /tmp/kiwiirc.tar.gz

# Verificar que se descargó correctamente
RUN ls -la /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
