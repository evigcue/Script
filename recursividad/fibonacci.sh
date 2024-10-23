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

# Función para imprimir los primeros n valores de la sucesión de Fibonacci
imprimir_fibonacci() {
    local n=$1
    for (( i=0; i<n; i++ )); do
        fibonacci $i
    done
}

read -p "Ingrese un número: " n

# Llamamos a la función para imprimir los primeros n valores
imprimir_fibonacci $n
