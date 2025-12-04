#!/bin/bash
# Script de inicio para ZNC

echo "--- Inicia el Add-on de ZNC ---"

# 1. Definir la ruta de datos para la persistencia
ZNC_DIR=/config/znc
ZNC_CONFIG_FILE="${ZNC_DIR}/configs/znc.conf"
# Aseguramos la existencia de los directorios
mkdir -p "${ZNC_DIR}/configs"

# 2. Configuración inicial: Solo si znc.conf NO existe
if [ ! -f "${ZNC_CONFIG_FILE}" ]; then
    echo "Configurando ZNC por primera vez en ${ZNC_DIR} con modo interactivo simulado."
    echo "Generando Listener web en el puerto 8888."
    
    # ⚠️ LA CORRECCIÓN CLAVE: Simulación completa de la sesión interactiva de znc --makeconf.
    # El orden y la cantidad de ENTERS es crucial.
    
    # 1. Iniciar el modo de configuración, forzando el directorio de datos
    (
        echo "8888"   # 1. Puerto del Listener Web (usamos 8888)
        echo "no"     # 2. Habilitar SSL/TLS
        echo "no"     # 3. ¿IPv6?
        echo ""       # 4. Aceptar Host global
        echo "user"   # 5. Nombre de usuario
        echo "temporal_pass_ha"  # 6. Contraseña
        echo "temporal_pass_ha"  # 7. Repetir Contraseña
        echo "no"     # 8. Añadir una red (Decimos 'no' para simplificar)
        echo "yes"    # 9. Guardar la configuración
    ) | znc --makeconf --datadir "${ZNC_DIR}"
    
    echo "Configuración inicial terminada. Usuario por defecto: user / Contraseña: temporal_pass_ha"
fi

# 3. Iniciar ZNC
echo "Lanzando ZNC. Los datos están en ${ZNC_DIR}."

# Quitamos el flag -r. Si la configuración es válida, ZNC no debería detenerse por el warning de root.
# Si se detiene, añadiremos 'sleep 30' al script y luego iniciaremos znc.
exec znc -d "${ZNC_DIR}" -f
