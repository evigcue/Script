#!/bin/bash

while true; do
    date +"%Y-%m-%d %H:%M:%S" | tee tiempo.txt
    sleep 5
done

# Cada 5 segundos muestra la fecha y hora en el archivo tiempo.txt 
# Al pasarlo de fg a bg o viceversa el proceso sigue, pero se ralentiza unos segundos debido al cambio
# Al matarlo deja de actualizar la fecha.