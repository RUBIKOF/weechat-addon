#!/bin/bash
# Script de inicio para Convos

echo "--- Inicia la configuración del Add-on de Convos ---"

# 1. Definir la ruta de datos para la persistencia
CONVOS_HOME=/data/convos
mkdir -p "${CONVOS_HOME}"

# 2. Configuración inicial (Solo si no existe)
if [ ! -f "${CONVOS_HOME}/convos.conf" ]; then
    echo "Configurando Convos por primera vez en ${CONVOS_HOME}..."
    # Configuración básica de Convos
    # Asegúrate de que Convos sepa dónde guardar sus datos
    # Utilizamos 'convos new' para generar la configuración y 'sed' para ajustar la ruta de logs
    convos new | sed "s|path_to_logs:.*|path_to_logs: ${CONVOS_HOME}/logs|" > "${CONVOS_HOME}/convos.conf"
    
    # ❗ NOTA: Puedes añadir aquí comandos para crear un usuario inicial si lo necesitas.
fi

# 3. Lanzar el servidor de Convos
echo "Lanzando Convos en el puerto 8080..."
# Lanza el demonio de Convos usando el directorio de Home Assistant para los datos
exec convos daemon \
     --listen "http://*:8080" \
     --home "${CONVOS_HOME}" \
     --config "${CONVOS_HOME}/convos.conf"
     
