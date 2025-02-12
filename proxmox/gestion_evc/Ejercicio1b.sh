#!/bin/bash

while IFS= read -r pool; do
    vmids=$(pvesh get /pools/"$pool" | grep -o 'qemu/[0-9]*' | awk -F/ '{print $2}')
    # Verifica si la pool contiene máquinas virtuales
    if [ -z "$vmids" ]; then
        echo "La pool '$pool' no contiene máquinas virtuales."
        exit 1
    fi
    backup_dir="/var/lib/vz/dump"
    # Crea copias de seguridad para cada VM en la pool
    echo "Iniciando copias de seguridad para la pool '$pool'..."
    for vmid in $vmids; do
        echo "Creando copia de seguridad para VM ID: $vmid..."
        vzdump "$vmid" --dumpdir "$backup_dir" --mode snapshot
    done
    echo "Copias de seguridad completadas. Archivos almacenados en: $backup_dir"
done < copias_seguridad_pool.txt