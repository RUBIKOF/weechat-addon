#!/usr/bin/env sh
set -e

echo "--- Iniciando KiwiIRC ---"

# Directorio de trabajo (por si quieres luego guardar algo en /config/kiwiirc)
KIWI_DIR=/config/kiwiirc
mkdir -p "${KIWI_DIR}"

cd /opt/kiwiirc

# Puerto donde escuchará KiwiIRC
export PORT=7778

# Lanzar KiwiIRC
exec npm start
