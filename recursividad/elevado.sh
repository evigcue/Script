#!/bin/bash
clear

function potencia(){
    local base=$1
    local potencia=$2
    if [ $potencia -eq 0 ]; then
        echo 1
    else
        local rdo=$(( $base * $(potencia $base $(( $potencia - 1 )) ) ))
        echo $rdo
    fi
}

read -p "Ingrese la base: " base
read -p "Ingrese la potencia: " potencia

potencia $base $potencia