#!/usr/bin/env sh

# Directorio de configuración de WeeChat
WEECHAT_HOME="/root/.weechat"

echo "Iniciando configuración de WeeChat IRC Server..."

# 1. CORRECCIÓN: Lee la configuración del Addon directamente desde el archivo usando jq
RELAY_PORT=$(jq -r '.relay_port' /data/options.json)
RELAY_PASSWORD=$(jq -r '.relay_password' /data/options.json)

# Verificación crucial en el log:
echo "Configurando WeeChat Relay en puerto $RELAY_PORT..."

# Exportar TERM es crucial
export TERM=xterm

# 2. Ejecutar WeeChat en background para crear los archivos de configuración
echo "Creando archivos de configuración iniciales de WeeChat..."
weechat -d "$WEECHAT_HOME" -q -n &
WEECHAT_PID=$!
sleep 5

if kill -0 "$WEECHAT_PID" 2>/dev/null; then
    kill "$WEECHAT_PID"
fi

# 3. Configurar el Relay de WeeChat (usando modo rooter -r)
# ELIMINAR CUALQUIER RELAY EXISTENTE
weechat -d "$WEECHAT_HOME" -r "relay del weechat"

# ESTABLECER LA CONTRASEÑA Y OPCIONES
weechat -d "$WEECHAT_HOME" -r "set relay.network.password \"$RELAY_PASSWORD\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.client_state \"disabled\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.ipv6 \"off\""

# AGREGAR EL SERVICIO RELAY CON EL PUERTO LEÍDO
weechat -d "$WEECHAT_HOME" -r "relay add weechat $RELAY_PORT"
echo "✅ Relay configurado."

# 4. Ejecución Final de WeeChat como Daemon
echo "Iniciando WeeChat en segundo plano..."
weechat -d "$WEECHAT_HOME"

# 5. Mantener el contenedor en ejecución (CRUCIAL)
echo "El addon está funcionando. Revisar logs para verificar la conexión del relay."
tail -f /dev/null
