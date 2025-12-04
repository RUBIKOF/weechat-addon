#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
# Definimos el directorio DONDE ZNC busca el archivo de configuración real
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
mkdir -p "${ZNC_DIR}/configs" # Aseguramos la existencia del subdirectorio 'configs'

# 2. Configuración inicial: Solo si znc.conf NO existe en la ruta correcta
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}."
    echo "Generando configuración mínima requerida en la ruta correcta."
    
    # Esto genera un hash de una contraseña temporal y la guarda en znc.conf
    # Usamos znc --makepass con redirección de salida al archivo en el subdirectorio 'configs'
    echo "temporal_pass_ha" | znc --makepass --datadir "${ZNC_DIR}" > "${ZNC_CONFIG_FILE}"
    
    # ⚠️ CORRECCIÓN DE SINTAXIS: Forzamos una línea en blanco y luego inyectamos el Listener Web.
    echo "" >> "${ZNC_CONFIG_FILE}" 
    
    # Paso Crucial: Añadir el Listener Web en el puerto 8888 al archivo generado
    echo "Añadiendo Listener web en el puerto 8888."
    cat >> "${ZNC_CONFIG_FILE}" << EOL
<Listener l>
    Port = 8888
    Host = 0.0.0.0
    SSL = false
</Listener>
EOL

    echo "Configuración inicial terminada. El usuario/contraseña debe configurarse en la web."
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# COMANDO FINAL: -d (datadir), -f (foreground), -r (allow-root).
exec znc -d "${ZNC_DIR}" -f -r
