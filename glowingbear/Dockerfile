FROM alpine:3.19

RUN apk add --no-cache nginx git ca-certificates && \
    update-ca-certificates

RUN mkdir -p /run/nginx /var/www

# Clonar Glowing Bear (frontend)
RUN git clone --depth 1 https://github.com/glowing-bear/glowing-bear.git /var/www/glowingbear && \
    chmod -R 755 /var/www/glowingbear

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
