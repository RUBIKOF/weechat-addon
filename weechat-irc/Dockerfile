FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
        jq \
        weechat \
        python3 \
        py3-pip && \
    rm -rf /var/cache/apk/*

COPY run.sh /

RUN mkdir -p /root/.weechat && \
    chmod a+x /run.sh

EXPOSE 8000

CMD ["/run.sh"]
