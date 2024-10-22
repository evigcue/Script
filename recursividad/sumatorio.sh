#!/bin/bash

function sumatorio (){
    local num=$1
    if [ $num -eq 1 ]; then
        echo "1"
    elif [ $num -eq 0 ]; then
        echo "0"
    else
        echo sumatorio $(( $num + $(sumatorio $(( $num - 1 ))) ))
    fi
}

read -p "Introduce hasta qué número es el sumatorio: " n

rdo=$(sumatorio "$n")

echo "El sumatorio de $n es $rdo"