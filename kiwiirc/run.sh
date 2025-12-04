#!/bin/bash
set -e
echo "=== Kiwi IRC Web Client ==="

# 1. Verificar estructura real
echo "Estructura de archivos:"
ls -la /var/www/html/

# 2. Kiwi IRC está en /var/www/html/kiwiirc/, moverlo a la raíz
if [ -d "/var/www/html/kiwiirc" ]; then
    echo "Reorganizando estructura de Kiwi IRC..."
    
    # Mover TODO el contenido de kiwiirc/ a la raíz
    mv /var/www/html/kiwiirc/* /var/www/html/ 2>/dev/null || true
    mv /var/www/html/kiwiirc/.* /var/www/html/ 2>/dev/null || true
    rmdir /var/www/html/kiwiirc 2>/dev/null || true
    
    echo "✓ Kiwi IRC movido a raíz"
fi

# 3. Verificar que ahora existe index.html
echo "Contenido actual:"
ls -la /var/www/html/

if [ ! -f "/var/www/html/index.html" ]; then
    echo "ERROR: Aún no hay index.html"
    echo "Buscando en subdirectorios..."
    find /var/www/html -name "index.html" -type f
    exit 1
fi

# 4. Configuración nginx SIMPLE (sin "user" directive)
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /var/www/html;
    index index.html;
    
    # Configuración básica
    autoindex off;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Archivos estáticos
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# 5. Probar configuración
nginx -t
echo "✓ Configuración nginx OK"

echo ""
echo "✅ Kiwi IRC listo en http://[TU_IP]:8080"
echo ""

exec nginx -g "daemon off;"
