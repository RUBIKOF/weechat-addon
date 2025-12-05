#!/bin/bash
set -e
echo "=== Kiwi IRC v1.7.1 ==="

# 1. Verificar estructura y permisos
echo "Verificando permisos..."
ls -la /var/www/html/
stat /var/www/html/index.html

# 2. Crear config.json
cd /var/www/html
cat > config.json << 'EOF'
{
    "windowTitle": "Kiwi IRC - HA",
    "startupScreen": "welcome",
    "restricted": false,
    "theme": "default",
    "startupOptions": {
        "server": "localhost",
        "port": 6667,
        "channel": "#homeassistant",
        "nick": "ha-${random}",
        "ssl": false,
        "autoconnect": false
    }
}
EOF

# 3. Asegurar permisos de config.json
chown www-data:www-data config.json
chmod 644 config.json

# 4. Configurar nginx CON usuario correcto
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /var/www/html;
    index index.html;
    
    # Usuario/grupo que coincide con permisos
    user www-data www-data;
    
    location / {
        try_files $uri $uri/ /index.html;
