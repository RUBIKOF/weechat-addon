#!/usr/bin/env sh

export TERM=xterm
WEECHAT_HOME="/root/.weechat"

echo "==== WeeChat IRC Server - init ===="

CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')

RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port // .options.relay_port // 8000')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password // .options.relay_password // "hassio"')

echo "Puerto configurado: $RELAY_PORT"
echo "Password configurado: $RELAY_PASSWORD"

mkdir -p "$WEECHAT_HOME"

# Crear config inicial
weechat -d "$WEECHAT_HOME" -r "/quit" || true

# Configurar relay
CMD="/plugin load relay;\
/set relay.network.password \"$RELAY_PASSWORD\";\
/set relay.network.bind_address \"0.0.0.0\";\
/set relay.network.ipv6 off;\
/relay del weechat;\
/relay add weechat $RELAY_PORT;\
/save;\
/quit"

weechat -d "$WEECHAT_HOME" -r "$CMD" || true

echo "Iniciando WeeChat en foreground…"
echo "VERÁS BASURA ANSI EN LOS LOGS (ES NORMAL)"

# ❗ EJECUTAR WEECHAT EN FOREGROUND (NUNCA USAR --daemon)
exec weechat -d "$WEECHAT_HOME"
