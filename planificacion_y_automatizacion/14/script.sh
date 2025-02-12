#!/bin/bash

# Comprobamos si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root." | tee /var/log/nuevos_usuarios.log
    exit 1
fi

# Comprobamos si existe el fichero usuarios_ficheros.txt
if [ ! -f ./usuarios_ficheros.txt ]; then
    echo "El fichero usuarios_ficheros.txt no existe." >> /var/log/nuevos_usuarios.log
    touch ./usuarios_ficheros.txt
    echo "Se ha creado el fichero usuarios_ficheros.txt" >> /var/log/nuevos_usuarios.log
    exit 1
fi

if [ -s ./usuarios_ficheros.txt ]; then
    while IFS= read -r user; do
        user=$(echo "$user" | awk -F ':' '{print $1}')
        # Comprobamos si el usuario existe en el sistema
        comprobacion=$(grep -wc "$user" /etc/passwd)
        # shellcheck disable=SC2086
        if [ $comprobacion -eq 1 ] ; then
            echo "El usuario $user existe" | tee /var/log/nuevos_usuarios.log
            # Sacamos la carpeta personal con awk
            home_dir=$(grep "$user" /etc/passwd | awk -F ':' '{print $6}')
            cp_dir=$(grep "$user" ./usuarios_ficheros.txt | awk -F ':' '{print $2}')
            if [ ! -e "$cp_dir" ]; then
                mkdir -p "$cp_dir"
            fi
            date=$(date '+%Y-%m-%d %H:%M:%S')
            echo "La carpeta personal de $user es $home_dir" | tee /var/log/nuevos_usuarios.log
            if [ ! -e "control.txt" ]; then
                touch control.txt
            fi
            tar -czf "$cp_dir/$user-$date.tar.gz" control.txt
            find "$home_dir" -name "*.txt" -mtime -30 -exec tar -rzf "$cp_dir/$user-$date.tar.gz" {} \;
            if [ $? -eq 0 ]; then
                echo "Se han copiado los ficheros de $user a $cp_dir" >> /var/log/nuevos_usuarios.log
            fi
        else
            echo "El usuario $user no existe" >> /var/log/nuevos_usuarios.log
        fi
    done < ./usuarios_ficheros.txt
else
    echo "El fichero usuarios_ficheros.txt esta vacio o no existe." >> /var/log/nuevos_usuarios.log
fi