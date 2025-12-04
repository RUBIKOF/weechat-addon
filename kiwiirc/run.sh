#!/bin/bash
echo "=== Kiwi IRC ==="

# Kiwi IRC está en /var/www/html/kiwiirc/
# Configurar nginx para usar esa subcarpeta como root
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    
    # Root APUNTA a la carpeta kiwiirc
    root /var/www/html/kiwiirc;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

echo "Verificando archivos en /var/www/html/kiwiirc/:"
ls -la /var/www/html/kiwiirc/

nginx -t
echo "Kiwi IRC disponible en: http://[TU_IP]:8080"

exec nginx -g "daemon off;"
