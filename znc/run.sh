#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
mkdir -p "${ZNC_DIR}/configs"

# ⚠️ PASO CRUCIAL: Limpiar la configuración antigua.
if [ -f "${ZNC_CONFIG_FILE}" ]; then
    echo "¡ADVERTENCIA! Eliminando configuración existente para forzar re-creación..."
    rm "${ZNC_CONFIG_FILE}"
fi

# 2. Configuración inicial: Solo si znc.conf NO existe
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Iniciando ZNC en modo de configuración para crear el archivo."
    echo "Este comando debe FALLAR INTENCIONALMENTE después de crear el archivo."
    
    # ⚠️ Forzamos el modo de configuración inicial de ZNC.
    # El comando -d (datadir) con --makeconf (no documentado) crea el archivo si no existe.
    znc --makeconf --datadir "${ZNC_DIR}"
    
    # ⚠️ IMPORTANTE: Añadir un pequeño retraso para asegurar que el archivo se escribe.
    sleep 2
    
    # Después de este paso, znc.conf debería existir, pero probablemente necesite un Listener.
    if [ -f "${ZNC_CONFIG_FILE}" ]; then
        echo "Archivo znc.conf creado. Inyectando Listener web en el puerto 8888."
        
        # ⚠️ Ya que el archivo fue creado por ZNC, la sintaxis de inyección de texto
        # es más segura (usamos una línea en blanco para mayor seguridad).
        
        echo "" >> "${ZNC_CONFIG_FILE}"
        cat >> "${ZNC_CONFIG_FILE}" << EOL
<Listener l>
    Port = 8888
    Host = 0.0.0.0
    SSL = false
</Listener>
EOL
    fi
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC en modo Daemon."
exec znc -d "${ZNC_DIR}" -f
