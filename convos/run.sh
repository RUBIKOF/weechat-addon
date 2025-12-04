#!/usr/bin/env bash
set -e

# Directorio de datos persistente
: "${CONVOS_HOME:=/data}"

if [ ! -d "$CONVOS_HOME" ]; then
  mkdir -p "$CONVOS_HOME"
fi

echo "Using CONVOS_HOME=${CONVOS_HOME}"

# Iniciar Convos escuchando en 0.0.0.0:3000
exec convos daemon -l http://0.0.0.0:3000 -f
