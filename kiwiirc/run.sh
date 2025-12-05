#!/bin/bash
echo "=== Kiwi IRC v1.7.1 ==="

# Ir al directorio construido
cd /var/www/html

# Crear config.json VÁLIDO
cat > config.json << 'EOF'
{
    "windowTitle": "Kiwi IRC - Home Assistant",
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

# Configurar nginx
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /var/www/html;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

echo "✅ Kiwi IRC construido desde fuente"
echo "🌐 http://[TU_IP]:8080"
echo "🔌 Conecta a: localhost:6667"

exec nginx -g "daemon off;"
