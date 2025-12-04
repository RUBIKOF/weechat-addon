#!/bin/sh
echo "=== Kiwi IRC Starting ==="
echo "Web interface: http://[TU_IP]:8080"
echo "Conecta a ZNC en: localhost:6667"
exec nginx -g "daemon off;"
