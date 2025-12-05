#!/bin/bash
echo "=== ZNC IRC Bouncer Starting ==="

ZNC_DIR=/config/znc
CONFIGS_DIR="${ZNC_DIR}/configs"
CONFIG_FILE="${CONFIGS_DIR}/znc.conf"

# Crear directorios necesarios
mkdir -p "${CONFIGS_DIR}"
mkdir -p "${ZNC_DIR}/modules"

# Solo crear la config la PRIMERA vez
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "No existe configuración, creando una por defecto..."

  cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

# Listener web (panel)
<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = false
    SSL = false
    AllowWeb = true
</Listener>

# Listener IRC para clientes (The Lounge, WeeChat, etc.)
<Listener irc>
    Port = 6667
    IPv4 = true
    IPv6 = false
    SSL = false
</Listener>

<User admin>
    Admin = true
    Nick = admin
    AltNick = admin_
    Ident = admin
    RealName = ZNC Administrator

    # Módulos básicos recomendados
    LoadModule = chansaver
    LoadModule = buffextras

    <Pass password>
        Method = sha256
        # Hash de "password"
        Hash = 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
    </Pass>
</User>
EOF

  echo "✓ Configuración inicial creada"
  echo "  Usuario: admin"
  echo "  Contraseña: password"
  echo "  Web UI: http://[TU_IP_HA]:8888"
else
  echo "Usando configuración existente en ${CONFIG_FILE}"
fi

echo "Iniciando ZNC..."
exec znc --allow-root -d "${ZNC_DIR}" -f
