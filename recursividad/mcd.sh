#!/bin/bash

function euclides() {
    local num1=$1
    local num2=$2
    # shellcheck disable=SC2086
    if [ $num1 -gt $num2 ]; then
        num1=$((num1 % num2))
    else
        num2=$((num2 % num1))
    fi
    # shellcheck disable=SC2086
    echo $num1 $num2
    # shellcheck disable=SC2086
    euclides $num1 $num2
}

read -rp "Ingrese el primer numero: " num1
read -rp "Ingrese el segundo numero: " num2

# shellcheck disable=SC2086
while [ $num1 -gt 0 ] && [ $num2 -gt 0 ]; do
    num1 $num2
done

echo "El MCD es: $num1"