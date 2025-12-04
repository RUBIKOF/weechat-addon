#!/bin/bash
echo "=== Kiwi IRC Reinstalación ==="

# 1. Eliminar todo
rm -rf /var/www/html/* /usr/share/kiwiirc

# 2. Reinstalar Kiwi IRC
wget -O /tmp/kiwiirc.deb \
    "https://kiwiirc.com/downloads/kiwiirc_20.05.24.1-1_arm64.deb" && \
dpkg-deb -x /tmp/kiwiirc.deb /tmp/kiwi && \
mv /tmp/kiwi/usr/share/kiwiirc /var/www/html/ && \
rm -rf /tmp/kiwiirc.deb /tmp/kiwi

# 3. Ir al directorio correcto
cd /var/www/html/kiwiirc

# 4. Configuración mínima
echo "{}" > config.json

# 5. nginx
echo 'server { listen 8080; root /var/www/html/kiwiirc; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

echo "Kiwi IRC reinstalado"
exec nginx -g "daemon off;"
