#!/bin/bash
set -x  # ← Activa modo debug
echo "--- Inicia el Add-on de ZNC ---"

ZNC_DIR=/config/znc
CONFIG_FILE="${ZNC_DIR}/znc.conf"
mkdir -p "${ZNC_DIR}"

# 1. Verificar/crear configuración
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creando configuración..."
    
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
    
    echo "✓ Config creada"
fi

# 2. VERIFICAR que la configuración es correcta
echo "=== VERIFICANDO CONFIGURACIÓN ==="
echo "Archivo: ${CONFIG_FILE}"
ls -la "${CONFIG_FILE}"
echo "--- Contenido del archivo ---"
cat "${CONFIG_FILE}"
echo "--- Fin del contenido ---"

# 3. Verificar que ZNC puede leer la config
echo "Probando configuración con ZNC..."
if znc -d "${ZNC_DIR}" --testconf; then
    echo "✓ Configuración VÁLIDA"
else
    echo "✗ Configuración INVÁLIDA"
    echo "Corrigiendo..."
    # Forzar recreación si es inválida
    rm -f "${CONFIG_FILE}"
    cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

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
    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
    </Pass>
</User>
EOF
fi

# 4. Verificar puertos abiertos ANTES de iniciar
echo "=== ESTADO DE PUERTOS ANTES ==="
netstat -tulpn || ss -tulpn || echo "No se puede ver puertos"

# 5. Iniciar ZNC en segundo plano para poder ver logs
echo "Iniciando ZNC..."
znc -d "${ZNC_DIR}" -f &
ZNC_PID=$!

# 6. Esperar a que ZNC inicie
echo "Esperando que ZNC inicie..."
sleep 5

# 7. Verificar si ZNC sigue corriendo
if kill -0 $ZNC_PID 2>/dev/null; then
    echo "✓ ZNC está corriendo (PID: $ZNC_PID)"
    
    # 8. Verificar puertos DESPUÉS de iniciar
    echo "=== ESTADO DE PUERTOS DESPUÉS ==="
    netstat -tulpn || ss -tulpn || echo "No se puede ver puertos"
    
    # 9. Ver logs de ZNC
    echo "=== ÚLTIMAS LÍNEAS DE LOG ==="
    tail -f "${ZNC_DIR}/znc.log" &
    TAIL_PID=$!
    sleep 3
    kill $TAIL_PID 2>/dev/null
    
    # 10. Mantener proceso principal vivo
    wait $ZNC_PID
else
    echo "✗ ZNC NO se está ejecutando"
    echo "Revisando logs..."
    cat "${ZNC_DIR}/znc.log" 2>/dev/null || echo "No hay logs"
    exit 1
fi
