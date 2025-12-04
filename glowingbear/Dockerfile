FROM alpine:3.19

RUN apk add --no-cache nginx git

# Crear directorios que usa nginx
RUN mkdir -p /run/nginx /var/www

# Descargar Glowing Bear
RUN git clone --depth 1 https://github.com/glowing-bear/glowing-bear.git /var/www/glowingbear

# Copiar nuestra config de nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
