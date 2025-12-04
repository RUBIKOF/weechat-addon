#!/usr/bin/env bash
set -e

WEB_PORT=3000
BOT_DIR="/usr/src/glowing_bear"

echo "==== Glowing Bear Web Client - init ===="

# 1. Leer opciones de Home Assistant para el puerto (si el usuario lo cambia)
CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')
WEB_PORT=$(echo "$CONFIG" | jq -r '.web_port // 3000')

echo "Iniciando Glowing Bear en el puerto $WEB_PORT..."

# 2. Establecer la variable de entorno para que el servidor Node sepa qué puerto usar
# Glowing Bear usa la variable de entorno PORT por defecto
export PORT=$WEB_PORT

# 3. Arrancar el servidor web de Glowing Bear
# El comando 'npm start' ejecuta el script de inicio definido en package.json (generalmente un servidor Node.js)
cd "$BOT_DIR"

# 'exec' asegura que Node.js sea el proceso principal del contenedor
exec npm start
