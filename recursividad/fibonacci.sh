#!/bin/bash

# Función recursiva para calcular el n-ésimo número de Fibonacci
fibonacci() {
    local n=$1
    if [ "$n" -le 0 ]; then
        echo 0
    elif [ "$n" -eq 1 ]; then
        echo 1
    else
        echo $(( $(fibonacci $(( n - 1 ))) + $(fibonacci $(( n - 2 ))) ))
    fi
}

read -p "Ingrese un número: " n

n=$(( ( n % 16 ) + 5 ))
# Llamamos a la función para imprimir los primeros n valores
fibonacci $n
