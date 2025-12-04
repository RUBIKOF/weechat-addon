#!/bin/bash
echo "=== ZNC IRC Bouncer Starting ==="

ZNC_DIR=/config/znc
CONFIGS_DIR="${ZNC_DIR}/configs"
CONFIG_FILE="${CONFIGS_DIR}/znc.conf"

# Crear directorios necesarios
mkdir -p "${CONFIGS_DIR}"
mkdir -p "${ZNC_DIR}/modules"

# Crear configuración en la ruta CORRECTA
cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = false
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
        Salt = salt1234
    </Pass>
</User>
EOF

echo "✓ Configuración creada en: ${CONFIG_FILE}"
echo "  Usuario: admin"
echo "  Contraseña: password"
echo "  Web UI: http://[TU_IP_HA]:8888"

# Iniciar ZNC
echo "Iniciando ZNC..."
exec znc --allow-root -d "${ZNC_DIR}" -f
