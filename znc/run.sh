#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia la configuración del Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
mkdir -p "${ZNC_DIR}"

# 2. Configuración inicial
if [ ! -f "${ZNC_DIR}/znc.conf" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}..."
    echo "Generando configuración inicial para el puerto web 8888."
    
    # ⚠️ COMANDO CORREGIDO: Usamos el comando znc --makeconf para generar el archivo
    # y lo forzamos a ser no interactivo (mediante una redirección de entrada)
    # y establecemos la configuración básica de un Listener.
    
    # 1. Creamos la configuración por lotes para el Listener web seguro (8888)
    # 2. Generamos una cuenta de usuario simple (user/pass) para que el usuario pueda iniciar sesión.
    # 3. ZNC necesita que le "alimentemos" la entrada con Enter (echo)
    
    # Este comando genera znc.conf sin interacción, asumiendo los valores por defecto
    # y añade el Listener en 8888.
    
    (
        echo "8888"   # 1. Puerto del Listener Web
        echo "yes"    # 2. Habilitar SSL/TLS (si el add-on tuviera soporte) -> Por simplicidad, decimos "yes" o "no"
        echo "no"     # 3. ¿IPv6?
        echo "admin"  # 4. Nombre de usuario
        echo "admin"  # 5. Contraseña
        echo "admin"  # 6. Repetir Contraseña
        echo "no"     # 7. Red por defecto
        echo "yes"    # 8. Guardar configuración
    ) | znc --makeconf --datadir "${ZNC_DIR}"
    
    echo "Configuración inicial terminada. Usuario/Contraseña por defecto: admin/admin"
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."
# ⚠️ COMANDO CORREGIDO: -d para el directorio de datos, -f para primer plano.
# ZNC ya está en la ruta, por lo que no es necesario el binario completo.
exec znc -d "${ZNC_DIR}" -f
