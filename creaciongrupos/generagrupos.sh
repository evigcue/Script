#!/bin/bash

# Comprobamos el último GID usado
lastgid=$(awk -F: '{ if ($3 > max_gid) max_gid=$3 } END { print max_gid }' /etc/group)

# Pedimos el prefijo y el número máximo de grupos a generar
read -rp "Introduce el prefijo para los grupos: " prefijo
read -rp "Introduce el número máximo de grupos a generar: " max_grupos

# Validamos que el máximo de grupos sea un número
if ! [[ "$max_grupos" =~ ^[0-9]+$ ]]; then
    echo "Error: El número máximo debe ser un número válido."
    exit 1
fi

# Generamos los grupos con el prefijo y números correlativos
for ((i=1; i<=max_grupos; i++))
do
    nuevo_grupo="${prefijo}${i}"
    nuevo_gid=$((lastgid + i))
    echo "Creando grupo: $nuevo_grupo con GID: $nuevo_gid"
    
    # Creamos el grupo
    groupadd -g "$nuevo_gid" "$nuevo_grupo"

    # Comprobamos si la creación fue exitosa
    if [ $? -ne 0 ]; then
        echo "Error creando el grupo $nuevo_grupo. Puede que ya exista o haya otro problema."
        exit 1
    fi
done

echo "Se han creado $max_grupos grupos con el prefijo $prefijo."