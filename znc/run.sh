#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
mkdir -p "${ZNC_DIR}/configs"

# 2. Crear usuario para ejecutar ZNC (evitar root)
if ! id -u znc >/dev/null 2>&1; then
    adduser --system --no-create-home --disabled-login --group znc
fi

# 3. Cambiar permisos
chown -R znc:znc "${ZNC_DIR}"

# 4. Configuración inicial: Solo si znc.conf NO existe
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Creando configuración inicial para ZNC..."
    
    # Crear archivo de configuración básico manualmente
    cat > "${ZNC_CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

<Listener listener1>
    Port = 6667
    IPv4 = true
    IPv6 = true
    SSL = false
</Listener>

<Listener listener2>
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
    Buffer = 50
    FloodBurst = 4
    FloodRate = 1.00
    TimestampFormat = [%H:%M:%S]

    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
        Salt = 1234567890
    </Pass>
</User>
EOF
    
    echo "Configuración inicial creada. IMPORTANTE: Cambia la contraseña después del primer login."
    echo "Contraseña por defecto: password"
    
    # Ahora ejecutamos ZNC para que complete la configuración
    su -s /bin/sh -c "znc --makeconf --datadir \"${ZNC_DIR}\" --foreground" znc
    sleep 3
fi

# 5. Verificar que el Listener esté configurado
if ! grep -q "Port = 8888" "${ZNC_CONFIG_FILE}"; then
    echo "Añadiendo Listener para puerto 8888..."
    echo "" >> "${ZNC_CONFIG_FILE}"
    cat >> "${ZNC_CONFIG_FILE}" << 'EOL'
<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = true
    SSL = false
    AllowWeb = true
</Listener>
EOL
fi

# 6. Verificar que haya al menos un usuario
if ! grep -q "<User " "${ZNC_CONFIG_FILE}"; then
    echo "ERROR: No hay usuarios configurados en znc.conf"
    echo "Elimina ${ZNC_CONFIG_FILE} para recrear la configuración"
    exit 1
fi

# 7. Iniciar ZNC como usuario znc
echo "Lanzando ZNC en modo Daemon como usuario znc..."
exec su -s /bin/sh -c "znc -d \"${ZNC_DIR}\" -f" znc
