#!/bin/bash

declare -A colores

key=1

while [ $key -ne 0 ]; do
    read -p "Introduzca el nombre del color (0 si quiere finalizar): " key
    if [ $key -ne 0 ]; then
        read -p "Introduce el valor hexadecimal de $key: " hexa
        colores[$key]="$hexa"
    fi
done

echo "Se han introducido ${#colores[@]} colores"
