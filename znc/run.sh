#!/bin/bash
echo "--- Inicia el Add-on de ZNC ---"

# Ruta de configuración
ZNC_DIR=/config/znc
mkdir -p $ZNC_DIR

# Cambiar a usuario znc para evitar warning de root
if id znc >/dev/null 2>&1; then
    chown -R znc:znc $ZNC_DIR
fi

# Verificar si ya existe configuración
if [ ! -f "$ZNC_DIR/znc.conf" ]; then
    echo "Creando configuración inicial..."
    
    # Crear configuración básica directamente
    cat > $ZNC_DIR/znc.conf << 'EOF'
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
        Salt = kd84jD8d
    </Pass>
</User>
EOF
    
    echo "Configuración creada. Usuario: admin, Contraseña: password"
fi

# Iniciar ZNC
echo "Iniciando ZNC..."
if id znc >/dev/null 2>&1; then
    exec su -s /bin/sh -c "znc -d $ZNC_DIR -f" znc
else
    exec znc -d $ZNC_DIR -f
fi
