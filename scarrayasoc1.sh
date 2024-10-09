#!/bin/bash

declare -A colores

echo "Se han introducido $# valores"

for i in "$@"; do 
    read -p "Introduce el valor hexadecimal para $i: " hexa
    colores[$i]=$hexa
done

echo "Los colores que puedes elegir son: "
for key in "${!colores[@]}"; do
    echo $key
done
