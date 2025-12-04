#!/bin/bash
echo "=== Kiwi IRC - Solución permisos ==="

# SOLUCIÓN RADICAL: Cambiar TODOS los permisos
chmod -R 777 /var/www/html 2>/dev/null || true

# Configuración nginx MUY permisiva
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /var/www/html;
    index index.html;
    
    # Desactivar user directive si causa problemas
    # user www-data;
    
    # Logs detallados
    access_log /dev/stdout;
    error_log /dev/stderr;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Crear archivo de prueba si no existe
if [ ! -f /var/www/html/test.txt ]; then
    echo "Archivo de prueba" > /var/www/html/test.txt
fi

echo "Archivos:"
ls -la /var/www/html/

echo "Iniciando nginx..."
exec nginx -g "daemon off;" 2>&1
