#!/bin/bash

declare -A newusers

logfile="/var/log/info_nuevos_usuarios.log"

while IFS=: read -r usu group home shell; do

    if getent passwd "$usu" > /dev/null; then
        echo $usu ya existe en el sistema >> "$logfile"
    else
        newusers[$usu]="$usu"

        #Comprobar que se ha especificado una shell
        if [ -z "$shell" ]; then
            shell="/bin/bash"
            echo "$(date '+%Y-%m-%d %H:%M:%S') No se especificó una shell para $usu. Se utilizará /bin/bash por defecto." >> "$logfile"
        fi

        #Comprobar que se ha especificado home
        if [ -z "$home" ]; then
            home="/home/$usu"
            echo "$(date '+%Y-%m-%d %H:%M:%S') No se especificó un directorio home para $usu. Se utilizará $home por defecto." >> "$logfile"
        fi

        echo "$(date '+%Y-%m-%d %H:%M:%S') Creando al usuario $usu" >> "$logfile"

        #Verificar la existencia del grupo especificado y crearlo si no es así
        if getent group "$group" > /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') $usu se unira al grupo $group" >> "$logfile"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') El grupo $group al que se intenta unir $usu no existe" >> "$logfile"
            echo "$(date '+%Y-%m-%d %H:%M:%S') Creando el grupo $group" >> "$logfile"
            groupadd "$group"

            #Verificar integridad de la creación de grupo
            if [ $? -eq 0 ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') El grupo $group se ha creado correctamente" >> "$logfile"
            else
                echo "$(date '+%Y-%m-%d %H:%M:%S') El grupo $group no se ha podido crear" >> "$logfile"
                echo "$(date '+%Y-%m-%d %H:%M:%S') El número de errores es $?" >> "$logfile"
                echo "$(date '+%Y-%m-%d %H:%M:%S') Se utilizará el grupo users" >> "$logfile"
                group=users
            fi
        fi

        useradd --ingroup "$group" -d "$home" -s "$shell" "${usu}"

        #Verificar integridad de la creación de usuario
        if [ $? -eq 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') El usuario $usu se creó correctamente" >> "$logfile"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') El usuario $usu no se pudo crear" >> "$logfile"
            echo "$(date '+%Y-%m-%d %H:%M:%S') El número de errores es $?" >> "$logfile"
        fi
    fi
done < users.txt

echo "$(date '+%Y-%m-%d %H:%M:%S') Se crearon los usuarios: " >> /var/log/nuevos_usuarios.log
for i in "${!newusers[@]}"; do
    echo "$i" >> /var/log/nuevos_usuarios.log
done