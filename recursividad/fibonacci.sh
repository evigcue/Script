#!/bin/bash

function fibonacci {
    local n=$1

    # Lo primero será especificar los casos base
    if [ $n -eq 0 ]; then
        echo 0
    elif [ $n -eq 1 ]; then
        echo 1
    elif [ $n -lt 0 ]; then
        echo "Fibonacci solo comprende números positivos"
    else
        echo $(( $(fibonacci $(( $n - 1 ))) + $(fibonacci $(( $n - 2 ))) ))
    fi
}

read -p "¿Hasta qué valor de fibonacci quieres?: " n

# Recorremos los valores de Fibonacci hasta el pedido
# El recorrer no funciona, por eso solo mostraré el valor pedido
# Da error en i<=n
for (( i=0; i<=$n; i++ )); do
   fibonacci $i
done

# Otra opción válida para el for es for i in $(seq 0 $n) que me lo hace en la secuencia de 0 a n.