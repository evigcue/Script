#!/bin/bash

read -rp "Introduce hasta qué número es el sumatorio: " n

function sumatorio (){
    if [ $n -eq 1 ]; then
        echo "1"
    else
        echo sumatorio $(( "$n" + $(sumatorio $(( "$n" -1 ))) ))
    fi
}

sumatorio "$n"