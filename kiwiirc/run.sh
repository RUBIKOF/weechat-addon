#!/usr/bin/env bash
set -e

echo "--- Iniciando KiwiIRC ---"

KIWI_DIR=/config/kiwiirc
mkdir -p "${KIWI_DIR}"

cd /opt/kiwiirc

# Puerto donde escuchará KiwiIRC
export PORT=7778

# Arrancamos KiwiIRC usando npm
exec npm start
