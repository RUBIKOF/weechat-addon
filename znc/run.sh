#!/bin/sh
set -e

echo "--- Inicia el Add-on de ZNC ---"

# Directorio de configuración
CONFIG_DIR="/config/znc"
CONFIG_FILE="${CONFIG_DIR}/znc.conf"

# Crear directorio
mkdir -p "${CONFIG_DIR}"

# Crear configuración si no existe
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creando configuración inicial..."
    
    # Crear archivo de configuración manualmente
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
    RealName = ZNC Administrator
    
    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
        Salt = znc_salt_123
    </Pass>
</User>
EOF
    
    echo "✓ Configuración creada"
    echo "  Usuario: admin"
    echo "  Contraseña: password"
    echo "  Web UI: http://[TU_IP]:8888"
fi

# Iniciar ZNC
echo "Iniciando ZNC..."
exec znc -f -d "${CONFIG_DIR}"
