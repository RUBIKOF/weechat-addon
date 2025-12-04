#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia la configuración del Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
mkdir -p "${ZNC_DIR}"

# 2. Configuración inicial
if [ ! -f "${ZNC_DIR}/znc.conf" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}..."
    echo "Generando configuración inicial simple. Por favor, usa la interfaz web para terminar la configuración."
    
    # ⚠️ COMANDO CORREGIDO: Usamos --makeconf y --batch para el modo no interactivo
    # y --datadir para especificar la ruta de guardado.
    znc --makeconf --datadir "${ZNC_DIR}" --batch
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# ⚠️ COMANDO CORREGIDO: -d para el directorio de datos, -f para primer plano.
exec znc -d "${ZNC_DIR}" -f
