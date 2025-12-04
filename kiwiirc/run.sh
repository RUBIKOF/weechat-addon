#!/bin/sh
set -e

echo "=== Kiwi IRC Web Client ==="

# Configurar nginx para usar configuración dinámica si existe
CONFIG_DIR="/config/kiwiirc"
CUSTOM_CONFIG="${CONFIG_DIR}/config.json"

if [ -f "${CUSTOM_CONFIG}" ]; then
    echo "Usando configuración personalizada de ${CUSTOM_CONFIG}"
    cp "${CUSTOM_CONFIG}" /usr/share/nginx/html/config.json
fi

echo "Web UI disponible en: http://[TU_IP]:8080"
echo "Conecta a ZNC en: localhost:6667"
echo ""

# Iniciar nginx
exec nginx -g 'daemon off;'
