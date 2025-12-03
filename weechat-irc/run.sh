#!/usr/bin/env sh

set -e

# 💡 Truco clave: darle un terminal válido a ncurses
export TERM=xterm

WEECHAT_HOME="/root/.weechat"

echo "==== WeeChat IRC Server - init ===="

# 1. Ver /data/options.json
if [ ! -f /data/options.json ]; then
  echo "ERROR: /data/options.json no existe"
  ls -R /data || true
fi

echo "Contenido de /data/options.json:"
cat /data/options.json || true
echo "=============================="

# 2. Leer opciones con jq (probamos raíz y .options.*)
CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')

RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port // .options.relay_port // 8000')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password // .options.relay_password // "hassio"')

echo "Puerto configurado: $RELAY_PORT"
echo "Password configurado: $RELAY_PASSWORD"

mkdir -p "$WEECHAT_HOME"

# 3. Primer arranque para generar estructura de config
echo "Primer arranque rápido para generar configuración base..."
weechat -d "$WEECHAT_HOME" -r "/quit" >/dev/null 2>&1 || true

# 4. Configurar relay desde WeeChat
echo "Configurando plugin relay..."
weechat -d "$WEECHAT_HOME" -r "
/plugin load relay;
/set relay.network.password \"$RELAY_PASSWORD\";
/set relay.network.bind_address \"0.0.0.0\";
/set relay.network.ipv6 off;
/relay del weechat;
/relay add weechat $RELAY_PORT;
/save;
/quit;
" >/dev/null 2>&1 || true

echo "Configuración de relay terminada. Arrancando WeeChat..."

# 5. Arrancar WeeChat como proceso principal del contenedor
exec weechat -d "$WEECHAT_HOME"
