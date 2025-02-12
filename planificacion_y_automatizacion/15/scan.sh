#!/bin/bash

date=$(date +"%Y-%m-%d %H:%M:%S")
temp="temp.txt"
output="nmap.txt"

# \033[31m$line - MUY PELIGROSO: puerto 22 abierto (SSH)\033[0m
# Lectura de las IP

while IFS= read -r line; do
    if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then  # Verifica el formato de la IP

        echo "leyendo la ip $line del fichero ip.txt"
        timeout 15 nmap -p- "$line" >> "$temp"  # Escanea la IP y guarda el resultado en el archivo de salida

    elif [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/[0-9]+$ ]]; then  # Si es una red completa
        echo "leyendo la red $line del fichero ip.txt"

        # Escanea la red completa y guarda el resultado en el archivo de salida
        nmap -p- "$line" >> "$temp"

    else
        echo "IP inválida: $line" >> "$temp"
    fi
done < ip.txt

echo "Escaneo completado a las $date" >> "$temp"
echo "---------- Fin del escaneo ----------" >> $temp

# Fin del informe

# Comienzo del informe

echo "---------- Escaneo del $date ----------" > $output

while IFS= read -r line; do
    if [[ "$line" =~ "22 tcp" ]]; then
        echo -e "\033[31mMUY PELIGROSO: puerto 22 abierto (SSH)\033[0m" >> "$output"
    else
        echo "$line" >> "$output"
    fi
done < temp.txt

echo "Informe del escaneo guardado en $output"