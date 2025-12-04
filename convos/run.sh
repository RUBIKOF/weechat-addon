#!/bin/bash
# Script de inicio para Convos

echo "--- Inicia la configuración del Add-on de Convos ---"

# 1. Definir la ruta de datos para la persistencia
# El directorio /data es gestionado y respaldado por Home Assistant Supervisor.
CONVOS_HOME=/data/convos
mkdir -p "${CONVOS_HOME}"

# 2. Configuración inicial (Solo si no existe)
# Esto asegura que Convos use el directorio de datos correcto
if [ ! -f "${CONVOS_HOME}/convos.conf" ]; then
    echo "Configurando por primera vez..."
    # Configuración básica de Convos
    # Asegúrate de que Convos sepa dónde guardar sus datos
    convos new | sed "s|path_to_logs:.*|path_to_logs: ${CONVOS_HOME}/logs|" > "${CONVOS_HOME}/convos.conf"
fi

# 3. Lanzar el servidor de Convos
echo "Lanzando Convos en el puerto 8080..."
# El comando "morbo" es para desarrollo, pero el comando de producción de Mojolicious
# que usa Convos es el que debemos ejecutar:
exec convos daemon \
     --listen "http://*:8080" \
     --home "${CONVOS_HOME}" \
     --config "${CONVOS_HOME}/convos.conf"
