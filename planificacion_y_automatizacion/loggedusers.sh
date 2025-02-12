#!/bin/bash

# Comprobamos si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Guardamos variables para después

date=$(date +"%Y-%m-%d %H:%M:%S")

# Comprobamos los usuarios

who > /tmp/usuarios_"$date".txt
