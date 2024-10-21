#!/bin/bash

logfile="/var/log/nuevos_usuarios.log"

if [ ! -f "$logfile" ] || [ ! -s "$logfile" ]; then
    echo "El archivo $logfile no existe o está vacío."
else
    while read -r usuario; do
        # Utilizamos una variable para verificar la contraseña
        auth=0
        # Pedir la contraseña para cada usuario
        while [ $auth -eq 0 ] ; do
            read -s -p "Contraseña para $usuario: " passwd
            echo
            read -s -p "Confirma la contraseña para $usuario: " passwd_confirm
            echo
            # Verificar si las contraseñas coinciden
            if [ "$passwd" != "$passwd_confirm" ]; then
                echo "Las contraseñas no coinciden. Inténtalo de nuevo."
            else
                # Cambiar la contraseña del usuario
                echo "$usuario:$passwd" | sudo chpasswd

                # Verificar si el comando chpasswd fue exitoso
                if [ $? -eq 0 ]; then
                    echo "Contraseña cambiada correctamente para el usuario $usuario."
                    auth=1
                else
                    echo "Error al cambiar la contraseña de $usuario. Inténtalo de nuevo."
                fi
            fi  
        done
    done < "$logfile"
fi

rm -f "$logfile"

echo "El proceso de cambio de contraseñas ha finalizado. El archivo $logfile ha sido borrado para evitar conflictos futuros."