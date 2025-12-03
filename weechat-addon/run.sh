#!/usr/bin/env bash

# Lee la configuración pasada por Home Assistant
CONFIG=$(</data/options.json)
HOST=$(echo "$CONFIG" | jq -r '.weechat_host')
PORT=$(echo "$CONFIG" | jq -r '.weechat_port')
PASSWORD=$(echo "$CONFIG" | jq -r '.weechat_password')

# --- Lógica de WeeChat o Bridge ---

# Si el objetivo es ejecutar el propio WeeChat dentro del addon:
# Necesitarías asegurarte de que WeeChat esté instalado en la imagen Docker base.
# Luego, iniciarlo en modo daemon o con el relay activado.
# weechat -r $HOST:$PORT --password $PASSWORD

# Si el objetivo es usar un script Python para interactuar con el WeeChat Relay:
# El script Python (ej. weechat_bridge.py) se encargaría de la comunicación.
python3 /app/weechat_bridge.py --host "$HOST" --port "$PORT" --password "$PASSWORD"

# Mantener el contenedor en ejecución para que HA no lo detenga
tail -f /dev/null
