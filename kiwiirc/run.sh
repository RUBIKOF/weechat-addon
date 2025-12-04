#!/bin/bash
echo "=== Kiwi IRC - Configuración directa ==="

# Ir directamente a donde está Kiwi IRC
cd /var/www/html/kiwiirc 2>/dev/null || cd /var/www/html

# Eliminar cualquier config.json corrupto
rm -f config.json config.js

# Crear config.json MINIMAL y FUNCIONAL
cat > config.json << 'EOF'
{}
EOF

# Configuración nginx ULTRA simple
echo 'server { listen 8080; root /var/www/html/kiwiirc; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

echo "Kiwi IRC funcionando en: http://[TU_IP]:8080"
exec nginx -g "daemon off;"
