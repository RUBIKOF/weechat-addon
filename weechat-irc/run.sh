#!/usr/bin/env sh

set -e

# Para que ncurses no llore
export TERM=xterm

WEECHAT_HOME="/root/.weechat"

echo "==== WeeChat IRC Server - init ===="

# 1. Leer opciones del addon
if [ ! -f /data/options.json ]; then
  echo "ERROR: /data/options.json no existe"
  ls -R /data || true
fi

echo "Contenido de /data/options.json:"
cat /data/options.json || true
echo "=============================="

CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')

RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port // .options.relay_port // 8000')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password // .options.relay_password // "hassio"')

echo "Puerto configurado: $RELAY_PORT"
echo "Password configurado: $RELAY_PASSWORD"

mkdir -p "$WEECHAT_HOME"

# 2. Primer arranque rápido para generar estructura
echo "Primer arranque rápido para generar configuración base..."
weechat -d "$WEECHAT_HOME" -r "/quit" || true

# 3. Configurar relay en una sola llamada
CMD="/plugin load relay;\
/set relay.network.password \"$RELAY_PASSWORD\";\
/set relay.network.bind_address \"0.0.0.0\";\
/set relay.network.ipv6 off;\
/relay del weechat;\
/relay add weechat $RELAY_PORT;\
/relay list;\
/save;\
/quit"

echo "Ejecutando comandos de configuración en WeeChat:"
echo "$CMD"

weechat -d "$WEECHAT_HOME" -r "$CMD"

echo "Contenido de $WEECHAT_HOME/relay.conf:"
if [ -f "$WEECHAT_HOME/relay.conf" ]; then
  echo "--------------------------------"
  cat "$WEECHAT_HOME/relay.conf"
  echo "--------------------------------"
else
  echo "relay.conf NO existe"
fi

echo "Configuración de relay terminada. Iniciando WeeChat en foreground..."
echo "OJO: verás basura ANSI en los logs, es normal."

# 4. WeeChat como proceso principal del contenedor (se queda vivo)
exec weechat -d "$WEECHAT_HOME"
