#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
# Aseguramos la existencia de los directorios
mkdir -p "${ZNC_DIR}/configs"

# 2. Configuración inicial: Solo si znc.conf NO existe en la ruta correcta
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}."
    echo "Generando configuración mínima requerida en la ruta correcta."
    
    # ⚠️ CORRECCIÓN CLAVE: Usamos printf para evitar caracteres ocultos en la entrada de ZNC --makepass.
    # El comando tr -d '\n' asegura que el hash no tenga saltos de línea finales.
    ZNC_HASH=$(printf 'temporal_pass_ha\ntemporal_pass_ha' | znc --makepass | tr -d '\n')
    
    # 2. Creamos el archivo de configuración completo con el hash y el Listener web.
    cat > "${ZNC_CONFIG_FILE}" << EOL
Version = 1.8.2
MaxUsers = 1
ProtectWebSessions = true

<Listener l>
    Port = 8888
    Host = 0.0.0.0
    SSL = false
</Listener>

<User user>
    Password = ${ZNC_HASH}
    Admin = true
    Nick = ZNCUser
    AltNick = ZNCUser_
    Ident = ZNCUser
    RealName = ZNC Home Assistant User
    
    <Network ha>
        Nick = HAUser
        AltNick = HAUser_
        Ident = HAUser
        RealName = HA User
    </Network>
</User>
EOL

    echo "Configuración inicial terminada. Usuario por defecto: user / Contraseña: temporal_pass_ha"
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# COMANDO FINAL: -d (datadir), -f (foreground), -r (allow-root).
exec znc -d "${ZNC_DIR}" -f -r
