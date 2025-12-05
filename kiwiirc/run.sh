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

# 2. Asegurar carpeta static (por si acaso)
mkdir -p "${WEB_ROOT}/static"

# 3. Definir un config.json MÍNIMO válido
CONFIG_JSON='{}'

# Escribirlo también en disco (no es obligatorio, pero no estorba)
echo "${CONFIG_JSON}" > "${WEB_ROOT}/config.json"
echo "${CONFIG_JSON}" > "${WEB_ROOT}/static/config.json"
echo "✓ config.json escrito en ${WEB_ROOT} y ${WEB_ROOT}/static"

# 4. Redirigir logs de nginx a stdout/stderr
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

# 5. Configurar nginx
cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 8080;
    server_name _;
    root ${WEB_ROOT};
    index index.html;

    # Rutas normales de la SPA
    location / {
        # Si la URL contiene "config" en el path → devolvemos siempre JSON
        if (\$uri ~* "config") {
            default_type application/json;
            return 200 '${CONFIG_JSON}';
        }

        try_files \$uri \$uri/ /index.html;
    }
}
EOF

echo "Configuración nginx:"
cat /etc/nginx/conf.d/default.conf

nginx -t

echo "✅ Kiwi IRC sirviéndose desde ${WEB_ROOT} en http://[TU_IP]:8080"

exec nginx -g "daemon off;"
