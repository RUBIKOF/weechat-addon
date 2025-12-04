#!/bin/bash
echo "--- Inicia el Add-on de ZNC ---"

ZNC_DIR=/config/znc
mkdir -p "${ZNC_DIR}"

# SOLUCIÓN: Crear configuración DIRECTAMENTE sin usar --makeconf
CONFIG_FILE="${ZNC_DIR}/znc.conf"

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creando configuración automáticamente..."
    
    # Crear configuración básica
    cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

<Listener irc>
    Port = 6667
    IPv4 = true
    IPv6 = true
    SSL = false
</Listener>

<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = true
    SSL = false
    AllowWeb = true
</Listener>

<User admin>
    Admin = true
    Nick = admin
    AltNick = admin_
    Ident = admin
    RealName = ZNC Admin
    
    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
        Salt = znc_salt_123
    </Pass>
</User>
EOF
    
    echo "Configuración creada. Usuario: admin, Contraseña: password"
    echo "Web UI: http://[TU_IP]:8888"
fi

# Iniciar ZNC
echo "Iniciando ZNC..."
exec znc -f -d "${ZNC_DIR}"
