#!/usr/bin/env sh

WEECHAT_HOME="/root/.weechat"

echo "Iniciando configuración de WeeChat IRC Server..."

# Leer opciones del addon
CONFIG=$(</data/options.json)
RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password')

export TERM=xterm

echo "Creando/actualizando archivos de configuración iniciales de WeeChat..."
# Primer arranque rápido para asegurar estructura de config
weechat -d "$WEECHAT_HOME" -r "quit" >/dev/null 2>&1 || true

echo "Cargando plugin relay..."
weechat -d "$WEECHAT_HOME" -r "plugin load relay; quit;" >/dev/null 2>&1 || true

echo "Configurando relay en puerto $RELAY_PORT..."
weechat -d "$WEECHAT_HOME" -r "
set relay.network.password \"$RELAY_PASSWORD\";
set relay.network.bind_address \"0.0.0.0\";
set relay.network.ipv6 \"off\";
relay del weechat;
relay add weechat $RELAY_PORT;
save;
quit;
"

echo "Iniciando WeeChat en modo daemon..."
weechat --daemon -d "$WEECHAT_HOME"

echo "WeeChat relay escuchando en puerto $RELAY_PORT"

# Mantener contenedor vivo
tail -f /dev/null
