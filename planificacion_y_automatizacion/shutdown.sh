#!/bin/bash

# Comprobar si es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Dentro de cinco horas, apagar el sistema si no quedan usuarios logueados.
usus=$(who | wc -l)
if [ $usus -eq 0 ]; then
    shutdown now "Apagando el equipo" >> /var/log/shutdown.log
    echo "El equipo se ha apagado." >> /var/log/shutdown.log
else
    echo "Los usuarios /n $(who) /n estan logueados." >> /var/log/shutdown.log
    echo "No se ha apagado el equipo." >> /var/log/shutdown.log
fi