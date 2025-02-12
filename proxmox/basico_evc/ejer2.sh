#!/bin/bash

info=/var/log/infousers.log
error=/var/log/errorusers.log

while IFS= read -r line; do
    user=$(echo "$line" | awk '{print $1}')

    # Comprobamos si el user ya existe
    authuser=$(pveum user list | grep -c "$user")
    if [ $authuser -ge 1 ]; then
        echo "El user $user existe" >> "$info"
    else
        echo "El user $user no existe" | tee "$info" "$error" > /dev/null
        echo "Creando user $user" >> "$info"
        pveum useradd "$user@pve" --password "$user"
        if [ $? -eq 0 ]; then
            echo "User $user creado con password $user" >> "$info"
        else
            echo "Error al crear el user $user" | tee -a "$info" "$error" > /dev/null
        fi
    fi

    # Sacamos las pools
    listpools=$(echo "$line" | awk -F: '{if (NF > 1) print $2}' | tr ',' '\n')
    echo "$listpools" | while IFS= read -r pool; do
        # Aseguramos que la pool existe
        authpool=$(pvesh get /cluster/resources --type pool | grep -w "$pool")
        if [ -z "$authpool" ]; then
            echo "La VM $pool no existe" | tee -a "$info" "$error" > /dev/null
        else
            echo "La VM $pool existe" >> "$info"

            # Añadimos el usuario a la pool
            pveum aclmod /pool/"$pool" --user "$user@pve" --role PVEPoolUser
            if [ $? -eq 0 ]; then
                echo "Usuario $user añadido a la pool $pool como PVEUser" >> "$info"
            else
                echo "Error al añadir el user $user a la pool $pool" | tee -a "$info" "$error" > /dev/null
            fi
        fi
    done
done < usuarios_mv.txt