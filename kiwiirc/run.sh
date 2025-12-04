#!/usr/bin/env sh
set -e

echo "--- Iniciando KiwiIRC ---"

KIWI_DIR=/config/kiwiirc
KIWI_INSTALL=/opt/kiwiirc

# Crear carpeta de config persistente
mkdir -p "$KIWI_DIR"

# Si no existe config.yaml en /config, copiar la predeterminada
if [ ! -f "$KIWI_DIR/config.yaml" ]; then
    echo "Copiando configuración por defecto a /config/kiwiirc/config.yaml"
    cp "$KIWI_INSTALL/config.example.yaml" "$KIWI_DIR/config.yaml"
fi

# Usar config.yaml persistente
export KIWI_CONFIG="$KIWI_DIR/config.yaml"

cd "$KIWI_INSTALL"

echo "--- Ejecutando servidor KiwiIRC ---"

exec node server/server.js --config "$KIWI_CONFIG"
