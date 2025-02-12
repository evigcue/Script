#!/bin/bash

# Comprobamos si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Realizamos (o actualizamos si ya existe) el backup de todos nuestros usuarios y los guardamos en la carpeta backup
for user in ($(cat /etc/passwd | cut -d ':' -f 1)); do
    if [ "$user" != "root" ]; then
        if [ -d "/backup" ]; then
            if [ ! -f "/backup/$user.tar.gz" ]; then
                tar -czf "/backup/$user.tar.gz" "/home/$user"
            else
                tar -uzf "/backup/$user.tar.gz" "/home/$user"
            fi
        else
            mkdir "/backup"
            if [ ! -f "/backup/$user.tar.gz" ]; then
                tar -czf "/backup/$user.tar.gz" "/home/$user"
            else
                tar -uzf "/backup/$user.tar.gz" "/home/$user"
            fi
        fi
    fi
done