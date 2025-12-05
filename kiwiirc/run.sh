#!/bin/bash
set -e

echo "=== Kiwi IRC Add-on ==="

WEB_ROOT="/var/www/html"
CONFIG_DIR="/config/kiwiirc"
OPTIONS_FILE="/data/options.json"

echo "Verificando contenido en ${WEB_ROOT}..."
ls -la "${WEB_ROOT}"

# 1. Verificar que exista el index.html de KiwiIRC
if [ ! -f "${WEB_ROOT}/index.html" ]; then
    echo "ERROR: No se encontró index.html de KiwiIRC en ${WEB_ROOT}"
    echo "<h1>Kiwi IRC Error</h1><p>No se encontró index.html.</p>" > "${WEB_ROOT}/index.html"
else
    echo "✓ index.html encontrado en ${WEB_ROOT}"
fi

# 2. Asegurar carpeta para config externa
mkdir -p "${CONFIG_DIR}"

# 3. Decidir qué config.json usar
if [ -f "${CONFIG_DIR}/config.json" ]; then
    echo "✓ Usando config externo: ${CONFIG_DIR}/config.json"
    cp "${CONFIG_DIR}/config.json" "${WEB_ROOT}/config.json"
else
    echo "No hay config externo, leyendo opciones del add-on..."

    CONFIG_FROM_OPTIONS=""
    if [ -f "${OPTIONS_FILE}" ]; then
        CONFIG_FROM_OPTIONS=$(python3 - << 'PY'
import json, sys
try:
    with open("/data/options.json", "r") as f:
        opts = json.load(f)
    cfg = opts.get("config_json", "").strip()
    if cfg:
        print(cfg)
except Exception as e:
    # Si algo falla, no imprimimos nada y dejamos que bash ponga el default
    pass
PY
)
    fi

    if [ -n "${CONFIG_FROM_OPTIONS}" ]; then
        echo "✓ Configuración obtenida de options.json"
        printf "%s\n" "${CONFIG_FROM_OPTIONS}" > "${WEB_ROOT}/config.json"
    else
        echo "⚠️ No se pudo leer config_json, usando configuración por defecto"
        cat > "${WEB_ROOT}/config.json" << 'EOF'
{
  "networks": [
    {
      "name": "Manual",
      "host": "",
      "port": 6667,
      "tls": false,
      "channels": []
    }
  ]
}
EOF
    fi
fi

echo "Contenido final de ${WEB_ROOT}/config.json:"
cat "${WEB_ROOT}/config.json" || echo "(!) No se pudo leer config.json"

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

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Servir config.json siempre como JSON
    location = /config.json {
        default_type application/json;
        try_files /config.json =404;
    }
}
EOF

echo "Configuración nginx:"
cat /etc/nginx/conf.d/default.conf

nginx -t

echo "✅ Kiwi IRC sirviéndose desde ${WEB_ROOT} en http://[TU_IP]:8080"

exec nginx -g "daemon off;"
