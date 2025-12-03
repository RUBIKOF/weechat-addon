#!/usr/bin/env sh

set -e

WEECHAT_HOME="/root/.weechat"
RELAY_CONF="$WEECHAT_HOME/relay.conf"

echo "Iniciando configuración de WeeChat IRC Server..."

# Leer opciones del addon
if [ ! -f /data/options.json ]; then
  echo "ERROR: /data/options.json no existe. ¿Se instaló bien el addon?"
  exit 1
fi

CONFIG=$(</data/options.json)
RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password')

export TERM=xterm

echo "Usando puerto de relay: $RELAY_PORT"
echo "Usando password de relay: $RELAY_PASSWORD"

# Asegurar que exista el directorio
mkdir -p "$WEECHAT_HOME"

echo "Generando relay.conf en $RELAY_CONF ..."

cat > "$RELAY_CONF" <<EOF
#
# WeeChat relay configuration file (generado por addon de HA)
#

[network]
port = $RELAY_PORT
password = "$RELAY_PASSWORD"
ipv6 = off
bind_address = "0.0.0.0"
max_clients = 5
ssl_cert_key = ""
compression = 0
allowed_ips = ""
EOF

echo "Contenido actual de relay.conf:"
echo "--------------------------------"
cat "$RELAY_CONF"
echo "--------------------------------"

echo "Iniciando WeeChat en modo daemon..."
weechat --daemon -d "$WEECHAT_HOME"

echo "WeeChat debería estar escuchando en puerto $RELAY_PORT (0.0.0.0:$RELAY_PORT)"

# Mantener contenedor vivo
tail -f /dev/null
