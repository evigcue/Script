#!/bin/bash

# Comprobamos si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Apagamos el equipo
shutdown now "Apagando el equipo"