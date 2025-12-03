#!/usr/bin/env sh

# Directorio de configuración de WeeChat
WEECHAT_HOME="/root/.weechat"

echo "Iniciando configuración de WeeChat IRC Server..."

# 1. Lee la configuración del Addon
CONFIG=$(</data/options.json)
RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password')

# 2. Configuración inicial y Relay Setup
# Exportar TERM es crucial para evitar el error 'ncurses: cannot initialize terminal type'
export TERM=xterm

# Ejecutar WeeChat en background (-d) para crear los archivos de configuración
# Usamos -q (quit) y -n (no-connect) para evitar errores de terminal y conexión
echo "Creando archivos de configuración iniciales de WeeChat..."
weechat -d "$WEECHAT_HOME" -q -n &
WEECHAT_PID=$!
sleep 5

# Intentamos asegurar que el proceso de configuración inicial termine
if kill -0 "$WEECHAT_PID" 2>/dev/null; then
    kill "$WEECHAT_PID"
fi

# 3. Configurar el Relay de WeeChat
echo "Configurando WeeChat Relay en puerto $RELAY_PORT..."

# Enviar comandos de configuración en modo rooter (-r)
weechat -d "$WEECHAT_HOME" -r "set relay.network.password \"$RELAY_PASSWORD\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.client_state \"disabled\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.ipv6 \"off\""

# Agregar el servicio Relay
weechat -d "$WEECHAT_HOME" -r "relay add weechat $RELAY_PORT"
echo "✅ Relay configurado."

# 4. Ejecución Final de WeeChat como Daemon
# Ejecutamos WeeChat en background (-d) para que el servicio se quede activo
echo "Iniciando WeeChat en segundo plano..."
weechat -d "$WEECHAT_HOME"

# 5. Mantener el contenedor en ejecución (CRUCIAL)
# Este comando evita que el contenedor Docker se detenga después de ejecutar el script.
echo "El addon está funcionando. Revisar logs para verificar la conexión del relay."
tail -f /dev/null
