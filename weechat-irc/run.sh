#!/usr/bin/env sh

# Salir si algo falla
set -e

# Para que ncurses no llore en los comandos de config
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

# 2. Leer opciones con jq (raíz y .options.* por compatibilidad)
CONFIG=$(cat /data/options.json 2>/dev/null || echo '{}')

RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port // .options.relay_port // 8000')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password // .options.relay_password // "hassio"')

echo "Puerto configurado: $RELAY_PORT"
echo "Password configurado: $RELAY_PASSWORD"

mkdir -p "$WEECHAT_HOME"

# 3. Primer arranque para generar estructura de config
echo "Primer arranque rápido para generar configuración base..."
weechat -d "$WEECHAT_HOME" -r "/quit" || true

# 4. Construir comando para configurar relay (una sola línea)
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

# 5. Ejecutar comando de configuración (veremos la salida en logs)
weechat -d "$WEECHAT_HOME" -r "$CMD"

echo "Contenido de $WEECHAT_HOME/relay.conf (si existe):"
if [ -f "$WEECHAT_HOME/relay.conf" ]; then
  echo "--------------------------------"
  cat "$WEECHAT_HOME/relay.conf"
  echo "--------------------------------"
else
  echo "relay.conf NO existe"
fi

echo "Configuración de relay terminada. Arrancando WeeChat en modo daemon..."

# 6. Ahora sí: WeeChat como servicio (sin interfaz), que se quede vivo
weechat --daemon -d "$WEECHAT_HOME"

echo "WeeChat daemon iniciado. Relay debería estar escuchando en 0.0.0.0:$RELAY_PORT"

# 7. Mantener el contenedor vivo para que el addon no se pare
tail -f /dev/null
