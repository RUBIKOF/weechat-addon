#!/bin/sh
set -e

echo "--- Inicia el Add-on de ZNC ---"

# Ruta de configuración
ZNC_DIR=/config/znc
CONFIG_FILE="${ZNC_DIR}/znc.conf"

# Crear directorios con permisos correctos
mkdir -p "${ZNC_DIR}"
chown znc:znc "${ZNC_DIR}"
chmod 755 "${ZNC_DIR}"

# Verificar si ya existe configuración
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creando configuración inicial..."
    
    # Crear archivo como root primero
    cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin
SSLCertFile = /ssl/fullchain.pem
SSLDHParamFile = /ssl/dhparams.pem
SSLKeyFile = /ssl/privkey.pem

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
    Buffer = 50
    
    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
        Salt = kd84jD8d
    </Pass>
</User>
EOF
    
    echo "Configuración creada en: ${CONFIG_FILE}"
    echo "Usuario: admin, Contraseña: password"
    echo "Accede a la interfaz web en: http://[TU_IP_HA]:8888"
    
    # Cambiar permisos del archivo de configuración
    chown znc:znc "${CONFIG_FILE}"
    chmod 644 "${CONFIG_FILE}"
fi

# Iniciar ZNC como usuario znc
echo "Iniciando ZNC como usuario znc..."
exec su-exec znc:znc znc -d "${ZNC_DIR}" -f
