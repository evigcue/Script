#!/bin/bash

clear

function sumatorio (){
    local num=$1
    if [ $num -eq 1 ]; then
        echo "1"
    elif [ $num -eq 0 ]; then
        echo "0"
    else
        local prev
        # Calculamos el sumatorio de num - 1 primero
        prev=$(sumatorio $((num - 1)))
        # Luego sumamos el valor actual de num con el valor anterior
        local rdo=$(( $num + $prev ))
        echo $rdo
    fi
}

read -p "Introduce hasta qué número es el sumatorio: " n

sumatorio $n