FROM alpine:3.19

RUN apk add --no-cache nginx git

RUN git clone https://github.com/glowing-bear/glowing-bear.git /var/www/glowingbear

# 👇 FIX: Dar permisos correctos a nginx
RUN chown -R nginx:nginx /var/www/glowingbear

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
