#!/bin/bash

# Comprobamos si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Escribimos la fecha y hora en un archivo
date +"%Y-%m-%d %H:%M:%S" >> ./tarea_programada.txt