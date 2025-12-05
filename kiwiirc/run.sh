#!/bin/bash
set -e

echo "=== Kiwi IRC Add-on ==="

WEB_ROOT="/var/www/html"

echo "Verificando contenido en ${WEB_ROOT}..."
ls -la "${WEB_ROOT}"

# 1. Verificar que exista el index.html de KiwiIRC
if [ ! -f "${WEB_ROOT}/index.html" ]; then
    echo "ERROR: No se encontró index.html de KiwiIRC en ${WEB_ROOT}"
    echo "<h1>Kiwi IRC Error</h1><p>No se encontró index.html.</p>" > "${WEB_ROOT}/index.html"
else
    echo "✓ index.html encontrado en ${WEB_ROOT}"
fi

# 2. Crear config.json vacío si no existe
if [ ! -f "${WEB_ROOT}/config.json" ]; then
    echo "{}" > "${WEB_ROOT}/config.json"
    echo "✓ config.json creado (vacío) en ${WEB_ROOT}"
else
    echo "✓ config.json ya existe en ${WEB_ROOT}"
fi

# 3. Configurar nginx para servir desde WEB_ROOT
cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 8080;
    server_name _;
    root ${WEB_ROOT};
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

echo "Configuración nginx:"
cat /etc/nginx/conf.d/default.conf

nginx -t

echo "✅ Kiwi IRC sirviéndose desde ${WEB_ROOT} en http://[TU_IP]:8080"

exec nginx -g "daemon off;"
