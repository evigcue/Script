#!/bin/bash

info=/var/log/infopools.log
error=/var/log/errorpools.log

while IFS= read -r line; do
    pool=$(echo "$line" | awk '{print $1}')

    # Comprobamos si el pool ya existe
    authpool=$(pvesh get /pools | grep -c "$pool")
    if [ $authpool -ge 1 ]; then
        echo "El pool $pool existe" >> "$info"
    else
        echo "El pool $pool no existe" | tee "$info" "$error" > /dev/null
        echo "Creando pool $pool" >> "$info"
        pvesh create /pools/"$pool"
    fi

    # Sacamos las vmid
    numvm=$(echo "$line" | awk -F: '{if (NF > 1) print $2}' | tr ',' '\n')
    echo "$numvm" | while IFS= read -r vm; do
        # Aseguramos que la vm existe
        authvm=$(pvesh get /cluster/resources --type vm | grep -w "$vm")
        if [ -z "$authvm" ]; then
            echo "La VM $vm no existe" | tee -a "$info" "$error" > /dev/null
        else
            echo "La VM $vm existe" >> "$info"

            # Añadimos la máquina a la pool
            pvesh set /pool/"$pool" --vmid "$vm"
            if [ $? -eq 0 ]; then
                echo "VM $vm movida al pool $pool" >> "$info"
            else
                echo "Error al mover la VM $vm al pool $pool" | tee -a "$info" "$error" > /dev/null
            fi
        fi
    done
done < pools_mv.txt