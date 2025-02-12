#!/bin/bash

info=/var/log/infoclonado.log
error=/var/log/errorclonado.log

while IFS= read -r line; do
    id=$(echo "$line" | awk '{print $1}')

    # Comprobamos si el id existe

    authvm=$(pvesh get /cluster/resources --type vm | jq -r '.[] | .vmid' | grep -w "$id")
    if [ -z "$authvm" ]; then
        echo "La VM $id no existe" | tee -a "$info" "$error" > /dev/null
        exit
    else
        echo "La VM $id existe" >> "$info"
        name=$(echo "$line" | awk '{print $2}')
        clonetype=$(echo "$line" | awk '{print $3}')
        if [ "$clonetype" != "full" ] && [ "$clonetype" != "linked" ]; then
            read -rp "Tipo de clonado no válido. Por favor ingrese 'full' o 'linked': " clonetype
        fi
        
        # Clonamos la máquina
        qm clone "$id" --name "$name" --"$clonetype"
        if [ $? -eq 0 ]; then
            echo "La VM $id clonada con nombre $name" >> "$info"
        else
            echo "Error al clonar la VM $id" | tee -a "$info" "$error" > /dev/null
        fi
    fi
done < clonaciones_mv.txt