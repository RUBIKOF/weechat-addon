#!/usr/bin/env sh

# Directorio de configuración de WeeChat
WEECHAT_HOME="/root/.weechat"

echo "Iniciando configuración de WeeChat IRC Server..."

# 1. Lee la configuración del Addon
CONFIG=$(</data/options.json)
RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password')

# Exportar TERM es crucial para evitar el error 'ncurses: cannot initialize terminal type'
export TERM=xterm

# 2. Ejecutar WeeChat en background para crear los archivos de configuración iniciales
echo "Creando archivos de configuración iniciales de WeeChat..."
# Usamos -q (quit) y -n (no-connect) solo para la fase de creación de archivos.
weechat -d "$WEECHAT_HOME" -q -n &
WEECHAT_PID=$!
sleep 5

# Intentamos asegurar que el proceso de configuración inicial termine
if kill -0 "$WEECHAT_PID" 2>/dev/null; then
    kill "$WEECHAT_PID"
fi

# 3. Configurar el Relay de WeeChat usando el modo rooter (-r)
echo "Configurando WeeChat Relay en puerto $RELAY_PORT..."

# Enviar comandos de configuración
weechat -d "$WEECHAT_HOME" -r "set relay.network.password \"$RELAY_PASSWORD\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.client_state \"disabled\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.ipv6 \"off\""

# Agregar el servicio Relay
weechat -d "$WEECHAT_HOME" -r "relay add weechat $RELAY_PORT"
echo "✅ Relay configurado."

# 4. Ejecución Final de WeeChat como Daemon
echo "Iniciando WeeChat en segundo plano..."
# Forzamos la carga del plugin relay justo antes de iniciar el daemon final (Solución para puertos cerrados)
weechat -d "$WEECHAT_HOME" -r "plugin load relay"
# Iniciamos el daemon final.
weechat -d "$WEECHAT_HOME"

# 5. Mantener el contenedor en ejecución (CRUCIAL)
echo "El addon está funcionando. Revisar logs para verificar la conexión del relay."
tail -f /dev/null
