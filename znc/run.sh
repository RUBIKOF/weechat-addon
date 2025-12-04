#!/usr/bin/env bash
set -e

# Linuxserver usa /init como entrypoint del contenedor
exec /init
