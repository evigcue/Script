#!/bin/bash

colores=colores.txt
declare -A colores

while IFS=':' read -r color hexa; do
    colores[$color]=$hexa
done<colores.txt

echo "Los colores que puedes elegir son: "
for key in "${!colores[@]}"; do
    echo "$key"
done

read -rp "¿Qué color quieres para el fondo de la página?" backcolor
read -rp "¿Qué color quieres para el parrafo de la página?" pcolor
read -rp "¿Qué color quieres para el texto de la página?" textcolor

echo "<style>
    *{
        background-color: ${color[$backcolor]};

        p{
        background-color: ${color[$pcolor];
        color: ${color[$textcolor]};
        }
    } 
</style>" >> style_esteban.html

ip=ifconfig

echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <link rel='stylesheet' href='style_esteban.css'>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Document</title>
</head>
<body>
    $ip
</body>
</html>" >> index_esteban.html