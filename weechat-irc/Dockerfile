FROM alpine:latest

# Instala dependencias: jq, WeeChat y Python
RUN apk update && \
    apk add --no-cache \
        jq \
        weechat \
        python3 \
        py3-pip && \
    rm -rf /var/cache/apk/*

# Copia script
COPY run.sh /

# Crea carpeta de config y da permisos
RUN mkdir -p /root/.weechat && \
    chmod a+x /run.sh

EXPOSE 8000

CMD ["/run.sh"]
