#!/bin/bash

source funciones_math.sh

clear

num1=$1
num2=$2

function menu {
    while true; do
        echo "----- MENÚ -----"
        echo "1. Suma"
        echo "2. Resta"
        echo "3. Multiplicación"
        echo "4. División"
        echo "5. Salir"
        read -rp "Elige una opción: " opcion

        case $opcion in
            1) suma $num1 $num2
                echo ;;
            2) resta $num1 $num2
                echo ;;
            3) multiplica 
                echo ;;
            4) divide 
                echo ;;
            5) echo
                echo "Gracias por usar la calculadora"
                exit ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

menu