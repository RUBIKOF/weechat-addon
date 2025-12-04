#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
mkdir -p "${ZNC_DIR}"

# 2. Configuración inicial: Solo si znc.conf NO existe
if [ ! -f "${ZNC_DIR}/znc.conf" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR}."
    echo "Generando configuración mínima requerida."
    
    # ⚠️ COMANDO CORREGIDO: Usamos --makepass para crear un archivo znc.conf minimalista.
    # Necesitamos pasar un password, aunque sea temporal. Lo canalizamos a la entrada.
    # La salida la redirigimos a znc.conf.
    
    # Esto genera un hash de una contraseña temporal y la guarda en znc.conf
    echo "temporal_pass_ha" | znc --makepass --datadir "${ZNC_DIR}" > "${ZNC_DIR}/znc.conf"
    
    # ⚠️ Paso Crucial: Añadir el Listener Web en el puerto 8888 al archivo generado
    echo "Añadiendo Listener web en el puerto 8888."
    cat >> "${ZNC_DIR}/znc.conf" << EOL
    
<Listener l>
    Port = 8888
    Host = 0.0.0.0
    SSL = false
    # Mantenemos el tipo por defecto (tapas, web, irc)
</Listener>
EOL

    echo "Configuración inicial terminada. El usuario/contraseña debe configurarse en la web."
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."
# ⚠️ COMANDO FINAL: -d para el directorio de datos, -f para primer plano.
exec znc -d "${ZNC_DIR}" -f
