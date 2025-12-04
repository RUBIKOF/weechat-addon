#!/bin/bash
echo "=== Kiwi IRC Web Client (aarch64) ==="

# Configuración personalizada si existe
CONFIG_DIR="/config/kiwiirc"
CONFIG_FILE="${CONFIG_DIR}/config.json"

mkdir -p "${CONFIG_DIR}"

if [ -f "${CONFIG_FILE}" ]; then
    cp "${CONFIG_FILE}" /var/www/html/config.json
    echo "✓ Usando configuración personalizada"
else
    echo "✓ Usando configuración por defecto"
fi

echo "Web UI: http://[TU_IP]:8080"
echo "Conecta a ZNC en: localhost:6667"
echo ""

exec nginx -g "daemon off;"
