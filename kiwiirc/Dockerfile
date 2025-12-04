FROM node:18-alpine AS builder

# Instalar dependencias para construir
RUN apk add --no-cache git python3 make g++

# Clonar y construir Kiwi IRC v1.7.1
RUN git clone --branch v1.7.1 --depth 1 \
    https://github.com/kiwiirc/kiwiirc.git /app \
    && cd /app \
    && npm install \
    && npm run build

FROM nginx:alpine

# Copiar Kiwi IRC construido
COPY --from=builder /app/dist /usr/share/nginx/html

# Configuración nginx básica
RUN echo 'server { \
    listen 8080; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 8080
