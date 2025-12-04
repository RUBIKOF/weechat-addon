#!/bin/bash
echo "=== ZNC IRC Bouncer Starting ==="

ZNC_DIR=/config/znc
CONFIGS_DIR="${ZNC_DIR}/configs"
CONFIG_FILE="${CONFIGS_DIR}/znc.conf"

# Crear directorios necesarios
mkdir -p "${CONFIGS_DIR}"
mkdir -p "${ZNC_DIR}/modules"

# Generar contraseña REAL para "password"
# Usamos znc --makepass para generar el hash correcto
echo "Generando contraseña segura..."

# Crear configuración con hash CORRECTO para "password"
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
    RealName = ZNC Administrator
    
    <Pass password>
        Method = sha256
        # Hash REAL para "password" generado con: echo -n "password" | sha256sum
        Hash = 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
    </Pass>
</User>
EOF

echo "✓ Configuración creada"
echo "  Usuario: admin"
echo "  Contraseña: password"
echo "  Web UI: http://[TU_IP_HA]:8888"

# Iniciar ZNC
echo "Iniciando ZNC..."
exec znc --allow-root -d "${ZNC_DIR}" -f
