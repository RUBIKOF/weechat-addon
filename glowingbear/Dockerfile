FROM alpine:3.19

RUN apk add --no-cache nginx git

# Descarga Glowing Bear
RUN git clone https://github.com/glowing-bear/glowing-bear.git /var/www/glowingbear

# Copiamos config de nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
