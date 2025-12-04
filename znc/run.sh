#!/bin/bash
echo "=== ZNC IRC Bouncer Starting ==="

ZNC_DIR=/config/znc
CONFIG_FILE="${ZNC_DIR}/znc.conf"
LOG_FILE="${ZNC_DIR}/znc.log"

# Crear directorio
mkdir -p "${ZNC_DIR}"

# Crear configuración SEGURA y FUNCIONAL
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

# Permitir que ZNC corra como root (necesario en contenedores HA)
echo "Iniciando ZNC (ignorando warning de root)..."
exec znc --allow-root -d "${ZNC_DIR}" -f
