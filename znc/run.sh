#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
mkdir -p "${ZNC_DIR}/configs"

# 2. Configuración inicial: Solo si znc.conf NO existe
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}."
    echo "Generando configuración mínima requerida y segura."
    
    # ⚠️ CORRECCIÓN CLAVE: Usamos 'strings' para eliminar todos los caracteres de control y nulos
    # de la salida del hash, eliminando la causa del error 'Malformed line'.
    ZNC_HASH=$(printf 'temporal_pass_ha\ntemporal_pass_ha\n' | znc --makepass | strings)
    
    # 2. Escribimos el archivo de configuración completo.
    echo "Escribiendo archivo de configuración en ${ZNC_CONFIG_FILE}"
    
    echo "Version = 1.8.2" > "${ZNC_CONFIG_FILE}"
    echo "MaxUsers = 1" >> "${ZNC_CONFIG_FILE}"
    echo "ProtectWebSessions = true" >> "${ZNC_CONFIG_FILE}"
    echo "" >> "${ZNC_CONFIG_FILE}"
    
    # Configuración del Listener Web (Puerto 8888)
    echo "<Listener l>" >> "${ZNC_CONFIG_FILE}"
    echo "    Port = 8888" >> "${ZNC_CONFIG_FILE}"
    echo "    Host = 0.0.0.0" >> "${ZNC_CONFIG_FILE}"
    echo "    SSL = false" >> "${ZNC_CONFIG_FILE}"
    echo "</Listener>" >> "${ZNC_CONFIG_FILE}"
    echo "" >> "${ZNC_CONFIG_FILE}"
    
    # Configuración del Usuario Inicial
    echo "<User user>" >> "${ZNC_CONFIG_FILE}"
    echo "    Password = ${ZNC_HASH}" >> "${ZNC_CONFIG_FILE}"
    echo "    Admin = true" >> "${ZNC_CONFIG_FILE}"
    echo "    Nick = ZNCUser" >> "${ZNC_CONFIG_FILE}"
    echo "    AltNick = ZNCUser_" >> "${ZNC_CONFIG_FILE}"
    echo "    Ident = ZNCUser" >> "${ZNC_CONFIG_FILE}"
    echo "    RealName = ZNC Home Assistant User" >> "${ZNC_CONFIG_FILE}"
    echo "</User>" >> "${ZNC_CONFIG_FILE}"
    
    echo "Configuración inicial terminada. Usuario por defecto: user / Contraseña: temporal_pass_ha"
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# Quitamos el flag -r y confiamos en la configuración válida.
exec znc -d "${ZNC_DIR}" -f
