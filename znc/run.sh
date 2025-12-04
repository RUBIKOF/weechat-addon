#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia la configuración del Add-on de ZNC ---"

ZNC_DIR=/config/znc
mkdir -p "${ZNC_DIR}"

# ZNC necesita que la configuración inicial se ejecute en el directorio del usuario root.
# Si el archivo de configuración principal (znc.conf) no existe, lo creamos de forma silenciosa.
if [ ! -f "${ZNC_DIR}/znc.conf" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}..."
    
    # ⚠️ MUY IMPORTANTE: Generar la configuración de ZNC de forma interactiva es imposible 
    # en un script de Add-on. Lo generamos en modo 'no interactivo'.
    # Usaremos el comando znc --makepass para generar una configuración de inicio simple
    # que luego el usuario deberá completar a través de la interfaz web.
    
    echo "Generando configuración inicial simple. Por favor, usa la interfaz web para terminar la configuración."
    
    # Generamos la configuración forzando la ruta
    znc -p "${ZNC_DIR}" --makepass
fi

# Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# Ejecutamos ZNC en primer plano (necesario para Docker)
exec znc -p "${ZNC_DIR}" -D

