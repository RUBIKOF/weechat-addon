#!/bin/bash
set -e

echo "=== Kiwi IRC Add-on ==="

WEB_ROOT="/var/www/html"

echo "Verificando contenido en ${WEB_ROOT}..."
ls -la "${WEB_ROOT}"

# 1. Verificar que exista el index.html de KiwiIRC
if [ ! -f "${WEB_ROOT}/index.html" ]; then
    echo "ERROR: No se encontró index.html de KiwiIRC en ${WEB_ROOT}"
    echo "<h1>Kiwi IRC Error</h1><p>No se encontró index.html.</p>" > "${WEB_ROOT}/index.html"
else
    echo "✓ index.html encontrado en ${WEB_ROOT}"
fi

# 2. Asegurar carpeta static (algunos builds buscan /static/config.json)
mkdir -p "${WEB_ROOT}/static"

# 3. Definir un config.json MÍNIMO válido
#    Por ahora es un JSON vacío; luego lo cambiamos por uno apuntando a tu ZNC
CONFIG_JSON='{}'

# (Opcional) escribirlo también en el filesystem, por si alguna vez decides servirlo como archivo
echo "${CONFIG_JSON}" > "${WEB_ROOT}/config.json"
echo "${CONFIG_JSON}" > "${WEB_ROOT}/static/config.json"
echo "✓ config.json escrito en ${WEB_ROOT} y ${WEB_ROOT}/static"

# 4. Configurar nginx
cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 8080;
    server_name _;
    root ${WEB_ROOT};
    index index.html;

    # Rutas normales: app SPA
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Kiwi suele pedir /config.json
    location = /config.json {
        default_type application/json;
        return 200 '${CONFIG_JSON}';
    }

    # Algunas builds usan /static/config.json
    location = /static/config.json {
        default_type application/json;
        return 200 '${CONFIG_JSON}';
    }
}
EOF

echo "Configuración nginx:"
cat /etc/nginx/conf.d/default.conf

nginx -t

echo "✅ Kiwi IRC sirviéndose desde ${WEB_ROOT} en http://[TU_IP]:8080"

exec nginx -g "daemon off;"
