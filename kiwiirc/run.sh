#!/bin/bash
set -e
echo "=== Kiwi IRC Debug ==="

# 1. Encontrar DÓNDE está realmente Kiwi IRC
echo "Buscando Kiwi IRC..."
find /var/www -name "index.html" -type f | head -5

# 2. Ir al directorio correcto
if [ -d "/var/www/html/kiwiirc" ]; then
    cd "/var/www/html/kiwiirc"
    echo "✓ Usando /var/www/html/kiwiirc"
elif [ -d "/usr/share/kiwiirc" ]; then
    cd "/usr/share/kiwiirc"
    echo "✓ Usando /usr/share/kiwiirc"
else
    cd "/var/www/html"
    echo "✓ Usando /var/www/html"
fi

# 3. ELIMINAR cualquier config.json corrupto
echo "Limpiando configuraciones previas..."
rm -f config.json config.js *.html 2>/dev/null || true

# 4. Crear config.json VACÍO y válido
echo "{}" > config.json
echo "✓ Config.json creado (vacío)"

# 5. Verificar que tenemos index.html
if [ ! -f "index.html" ]; then
    echo "ERROR: No hay index.html en $(pwd)"
    ls -la
    echo "<h1>Kiwi IRC Error</h1>" > index.html
fi

# 6. Configurar nginx para servir desde ESTE directorio
NGINX_ROOT=$(pwd)
cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 8080;
    server_name _;
    root $NGINX_ROOT;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Forzar JSON para config.json
    location = /config.json {
        add_header Content-Type application/json;
        try_files /config.json =404;
    }
}
EOF

# 7. Verificar
echo "Directorio actual: $(pwd)"
echo "Archivos:"
ls -la
echo ""
echo "Contenido de config.json:"
cat config.json
echo ""
echo "Configuración nginx:"
cat /etc/nginx/conf.d/default.conf

nginx -t
echo "✅ Kiwi IRC en: http://[TU_IP]:8080"

exec nginx -g "daemon off;"
