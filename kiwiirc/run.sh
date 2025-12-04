#!/bin/sh
set -e

echo "=== Kiwi IRC Web Client Starting ==="

CONFIG_DIR="/config/kiwiirc"
CONFIG_FILE="${CONFIG_DIR}/config.json"

# Crear directorio de configuración
mkdir -p "${CONFIG_DIR}"

# Obtener variables de opciones (de config.yaml del addon)
ZNC_HOST="${znc_host:-localhost}"
ZNC_PORT="${znc_port:-6667}"
ZNC_SSL="${znc_ssl:-false}"
DEFAULT_SERVER="${default_server:-localhost}"
DEFAULT_PORT="${default_port:-6667}"
DEFAULT_CHANNEL="${default_channel:-#homeassistant}"

# Crear configuración de Kiwi IRC
cat > "${CONFIG_FILE}" << EOF
{
  "windowTitle": "Kiwi IRC - Home Assistant",
  "startupScreen": "welcome",
  "kiwiServer": "/webirc/kiwiirc/",
  "restricted": false,
  "theme": "default",
  "themes": [
    { "name": "Default", "url": "static/themes/default" },
    { "name": "Dark", "url": "static/themes/dark" }
  ],
  "buffers": {
    "messageLayout": "compact",
    "show_emoticons": true,
    "show_timestamps": true,
    "show_joinparts": true
  },
  "startupOptions": {
    "server": "${DEFAULT_SERVER}",
    "port": ${DEFAULT_PORT},
    "channel": "${DEFAULT_CHANNEL}",
    "nick": "ha-user-",
    "ssl": ${ZNC_SSL},
    "password": "",
    "autoconnect": false
  },
  "transports": [
    {
      "name": "kiwiirc",
      "handler": "jsonipc",
      "url": "{{server}}/webirc/kiwiirc/"
    }
  ],
  "plugins": [
    {
      "name": "kiwiirc-plugin-emojis",
      "url": "static/plugins/emojis/plugin.js"
    },
    {
      "name": "kiwiirc-plugin-themes",
      "url": "static/plugins/themes/plugin.js"
    }
  ]
}
EOF

echo "✓ Configuración creada en: ${CONFIG_FILE}"
echo "  Conectando a ZNC en: ${ZNC_HOST}:${ZNC_PORT}"
echo "  Web UI: http://[TU_IP_HA]:8080"

# Servir Kiwi IRC
echo "Iniciando Kiwi IRC..."
cd /app && exec serve -s dist -l 8080
