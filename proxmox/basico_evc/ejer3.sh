#!/bin/bash

info=/var/log/infoplantilla.log
error=/var/log/errorplantilla.log

while IFS= read -r line; do
    id=$(echo "$line" | awk '{print $1}')

    # Comprobamos si el id existe
    authid=$(pvesh get /pools | grep -c "$id")
    if [ $authid -ge 1 ]; then
        echo "La máquina $id existe" >> "$info"
    else
        echo "La máquina $id no existe" | tee "$info" "$error" > /dev/null
        echo "Imposible hacer la clonación de una máquina inexistente" | tee "$info" "$error" > /dev/null
    fi

    # Sacamos el nombre de la vm
    name=$(echo "$line" | awk '{print $2}')

    # Clonamos la máquina
    qm template "$id" --name "$name"
    if [ $? -eq 0 ]; then
        echo "La máquina $id clonada con nombre $name" >> "$info"
    else
        echo "Error al clonar la VM $id" | tee -a "$info" "$error" > /dev/null
    fi

    # Añadimos la clonación a la pool
    listpools=$(echo "$line" | awk -F: '{if (NF > 1) print $3}' | tr ',' '\n')
    echo "$listpools" | while IFS= read -r pool; do
    
        # Aseguramos que la pool existe
        authpool=$(pvesh get /cluster/resources --type pool | grep -w "$pool")
        if [ -z "$authpool" ]; then
            echo "La pool $pool no existe" | tee -a "$info" "$error" > /dev/null
        else
            echo "La pool $pool existe" >> "$info"

            # Añadimos la máquina a la pool
            vmid=$(pvesh get /cluster/resources --type vm | grep -w "$name" | awk '{print $1}')
            pvesh set /pool/"$pool" --vmid "$vmid"
            if [ $? -eq 0 ]; then
                echo "VM $name movida al pool $pool" >> "$info"
            else
                echo "Error al mover la VM $name al pool $pool" | tee -a "$info" "$error" > /dev/null
            fi
        fi
    done
done < plantillas_mv.txt