#!/usr/bin/env bash
set -e

# Lee opciones del add-on
CONFIG_PATH="/data/options.json"

if [ -f "$CONFIG_PATH" ]; then
    INVITE_CODE=$(jq -r '.invite_code // empty' "$CONFIG_PATH")

    if [ -n "$INVITE_CODE" ]; then
        export CONVOS_INVITE_CODE="$INVITE_CODE"
    fi
fi

# Iniciar Convos
exec convos daemon -f
