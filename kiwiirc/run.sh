#!/bin/bash
echo "=== Kiwi IRC Web Client Starting ==="

# Directorios
KIWI_DIR="/config/kiwiirc"
CONFIG_FILE="${KIWI_DIR}/config.json"

# Crear directorio si no existe
mkdir -p "${KIWI_DIR}"

# Crear configuración personalizada si no existe
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creando configuración personalizada..."
    
    cat > "${CONFIG_FILE}" << 'EOF'
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
  }
}
EOF
    
    echo "✓ Configuración creada en: ${CONFIG_FILE}"
fi

# Copiar configuración personalizada al directorio web
if [ -f "${CONFIG_FILE}" ]; then
    cp "${CONFIG_FILE}" /var/www/html/config.json
    echo "Usando configuración personalizada"
fi

echo "Web UI disponible en: http://[TU_IP_HA]:8080"
echo "Conecta a ZNC en: localhost:6667"
echo ""

# Iniciar nginx
echo "Iniciando servidor web..."
exec nginx -g "daemon off;"
