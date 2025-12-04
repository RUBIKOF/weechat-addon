#!/bin/bash
set -e
echo "=== Kiwi IRC Web Client ==="

# 1. Verificar estructura
echo "Contenido de /var/www/html/:"
ls -la /var/www/html/

# 2. Si hay carpeta kiwiirc, usar esa como root
if [ -d "/var/www/html/kiwiirc" ]; then
    echo "Usando carpeta kiwiirc como root..."
    KIWI_ROOT="/var/www/html/kiwiirc"
else
    echo "Usando raíz..."
    KIWI_ROOT="/var/www/html"
fi

# 3. Verificar que existe index.html
if [ ! -f "$KIWI_ROOT/index.html" ]; then
    echo "ERROR: No se encontró Kiwi IRC"
    find /var/www/html -name "*.html" -type f
    exit 1
fi

# 4. Crear config.json VÁLIDO para Kiwi IRC
CONFIG_FILE="$KIWI_ROOT/config.json"
echo "Creando configuración Kiwi IRC..."

cat > "$CONFIG_FILE" << 'EOF'
{
    "windowTitle": "Kiwi IRC - Home Assistant",
    "startupScreen": "welcome",
    "restricted": false,
    "theme": "default",
    "themes": [
        { "name": "Default", "url": "static/themes/default" },
        { "name": "Dark", "url": "static/themes/dark" }
    ],
    "startupOptions": {
        "server": "localhost",
        "port": 6667,
        "channel": "#homeassistant",
        "nick": "ha-${random}",
        "ssl": false,
        "autoconnect": false
    },
    "plugins": []
}
EOF

echo "✓ Configuración creada: $CONFIG_FILE"

# 5. Configuración nginx para servir desde la carpeta correcta
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /var/www/html/kiwiirc;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Archivos estáticos
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Configuración Kiwi IRC
    location = /config.json {
        add_header Content-Type application/json;
    }
}
EOF

# 6. Verificar que config.json es JSON válido
echo "Validando config.json..."
if python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
    echo "✓ JSON válido"
else
    echo "✗ JSON inválido, mostrando contenido:"
    cat "$CONFIG_FILE"
fi

# 7. Probar nginx
nginx -t
echo "✅ Kiwi IRC listo en: http://[TU_IP]:8080"
echo "🔌 Conecta a ZNC: localhost:6667"

exec nginx -g "daemon off;"
