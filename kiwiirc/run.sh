#!/bin/bash
set -e  # Detener en primer error
set -x  # Modo debug

echo "=== Kiwi IRC Web Client (aarch64) ==="

# Verificar que Kiwi IRC existe
echo "Verificando archivos de Kiwi IRC..."
ls -la /var/www/html/

# Configuración personalizada
CONFIG_DIR="/config/kiwiirc"
CONFIG_FILE="${CONFIG_DIR}/config.json"
mkdir -p "${CONFIG_DIR}"

if [ -f "${CONFIG_FILE}" ]; then
    cp "${CONFIG_FILE}" /var/www/html/config.json
    echo "✓ Usando configuración personalizada"
else
    echo "✓ Usando configuración por defecto"
    # Crear configuración básica
    cat > /var/www/html/config.json << 'EOF'
{
  "windowTitle": "Kiwi IRC - HA",
  "startupOptions": {
    "server": "localhost",
    "port": 6667,
    "channel": "#homeassistant",
    "nick": "ha-${random}",
    "ssl": false
  }
}
EOF
fi

# Verificar configuración nginx
echo "Configuración nginx:"
cat /etc/nginx/nginx.conf 2>/dev/null || echo "No hay nginx.conf principal"
ls -la /etc/nginx/conf.d/

# Crear configuración nginx si no existe
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
    echo "Creando configuración nginx..."
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
fi

# Verificar puerto 8080
echo "Verificando puerto 8080..."
netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null || echo "No se puede ver puertos"

# Probar si nginx puede iniciar
echo "Probando configuración nginx..."
nginx -t

echo "Iniciando nginx en puerto 8080..."
echo "Web UI: http://[TU_IP]:8080"
echo "Conecta a ZNC en: localhost:6667"

# Iniciar nginx en primer plano
exec nginx -g "daemon off;"
