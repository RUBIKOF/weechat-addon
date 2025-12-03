#!/bin/sh
set -e

# Configura el relay con la contraseña del addon
PASSWORD=$(echo -n "${PASSWORD}" | sed 's/[\/&]/\\&/g')
sed -i "s/\/set relay.network.password.*/\/set relay.network.password ${PASSWORD}/g" /home/weechat/.weechat/relay.conf

# Inicia WeeChat en modo headless con relay
exec weechat --dir /home/weechat/.weechat --daemon \
    --run "/set relay.network.bind_address '0.0.0.0'; /relay add weechat 9001;"
