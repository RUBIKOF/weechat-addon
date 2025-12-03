#!/usr/bin/env bash

set -e

WEECHAT_HOME="/root/.weechat"

echo "==== WeeChat IRC Server (headless) - init ===="

if [ ! -f /data/options.json ]; then
  echo "ERROR: /data/options.json no existe"
fi

CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')

RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port // .options.relay_port // 8000')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password // .options.relay_password // "hassio"')

echo "Puerto configurado: $RELAY_PORT"
echo "Password configurado: $RELAY_PASSWORD"

mkdir -p "$WEECHAT_HOME"

echo "Primer arranque rápido para crear estructura de config..."
weechat-headless -d "$WEECHAT_HOME" -r "/quit" >/dev/null 2>&1 || true

# Configurar relay
CMD="/plugin load relay;\
/set relay.network.password \"$RELAY_PASSWORD\";\
/set relay.network.bind_address \"0.0.0.0\";\
/set relay.network.ipv6 off;\
/relay del weechat;\
/relay add weechat $RELAY_PORT;\
/relay list;\
/save;\
/quit"

echo "Ejecutando comandos de configuración en WeeChat headless:"
echo "$CMD"

weechat-headless -d "$WEECHAT_HOME" -r "$CMD" >/dev/null 2>&1 || true

echo "Contenido de $WEECHAT_HOME/relay.conf:"
if [ -f "$WEECHAT_HOME/relay.conf" ]; then
  echo "--------------------------------"
  cat "$WEECHAT_HOME/relay.conf"
  echo "--------------------------------"
else
  echo "relay.conf NO existe"
fi

echo "Arrancando WeeChat headless como proceso principal…"

# 👇 Aquí sí: proceso principal del contenedor, sin TUI, sin daemon raro
exec weechat-headless -d "$WEECHAT_HOME"
