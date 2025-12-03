#!/usr/bin/env bash

# Directorio de WeeChat dentro del contenedor Docker
WEECHAT_HOME="/root/.weechat"

echo "Iniciando configuración de WeeChat IRC Server..."

# 1. Lee la configuración del Addon
CONFIG=$(</data/options.json)
RELAY_PORT=$(echo "$CONFIG" | jq -r '.relay_port')
RELAY_PASSWORD=$(echo "$CONFIG" | jq -r '.relay_password')

# 2. Configura el Relay en WeeChat
# Para configurar el relay, necesitamos asegurarnos de que el plugin esté cargado
# y establecer las opciones de manera persistente.

# Creamos el directorio si no existe (el Dockerfile ya lo hace, pero es buena práctica)
mkdir -p "$WEECHAT_HOME"

# Ejecutamos WeeChat una vez en background para crear los archivos de configuración
# si es la primera vez que se ejecuta.
weechat -d "$WEECHAT_HOME" -q &
WEECHAT_PID=$!
sleep 5 # Dar tiempo a WeeChat para que inicialice archivos
kill $WEECHAT_PID # Detenemos la instancia inicial

# 3. Aplicar configuración de Relay
echo "Configurando WeeChat Relay en puerto $RELAY_PORT..."

# Estos comandos modifican directamente los archivos de configuración
# Primero, habilitar el plugin relay si no está
weechat -d "$WEECHAT_HOME" -r "plugin load relay"

# 4. Establecer las opciones de conexión segura
weechat -d "$WEECHAT_HOME" -r "set relay.network.password \"$RELAY_PASSWORD\""
weechat -d "$WEECHAT_HOME" -r "set relay.network.client_state \"disabled\"" # Opcional, pero recomendado
weechat -d "$WEECHAT_HOME" -r "set relay.network.ipv6 \"off\"" # Puede ser problemático

# 5. Agregar el servicio Relay (Ej. usando el protocolo weechat, no websocket)
# Si ya existe, este comando puede fallar. Se recomienda editar el archivo directamente si es complejo.
# Por simplicidad, usamos la interfaz de comando:
weechat -d "$WEECHAT_HOME" -r "relay add weechat $RELAY_PORT"
echo "Relay configurado. Asegúrate de que el plugin esté cargado en /root/.weechat/weechat.conf"


# 6. Ejecución Final de WeeChat en modo demonio (background)
# Usaremos 'weechat -d' para ejecutarlo en segundo plano y luego 'tail' para mantener el contenedor vivo
echo "Iniciando WeeChat en segundo plano..."
weechat -d "$WEECHAT_HOME"

# 7. Mantener el contenedor en ejecución (Crucial para Addons)
echo "El addon está funcionando. Revisar logs para verificar la conexión del relay."
tail -f /dev/null
