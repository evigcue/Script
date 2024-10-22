#!/bin/bash

aciertos=/var/log/aciertos.log
errores=/var/log/errores.log

function menu {
  while true; do
    echo "----- MENÚ -----"
    echo "1. Ver grupos creados"
    echo "2. Ver grupos no creados"
    echo "3. Salir"
    # shellcheck disable=SC2162
    read -p "Elige una opción: " opcion

    case $opcion in
      1) eval"$(cat $aciertos)" ;;
      2) eval"$(cat $errores)" ;;
      3) exit ;;
      *) echo "Opción no válida." ;;
    esac
  done
}

while IFS=':' read -r gid grupo; do
  if ! getent group "$gid" > /dev/null ; then
    addgroup -g "$gid" "$grupo"
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then 
      echo "Grupo '$grupo' creado con gid $gid." >> $aciertos
    elsse
      echo "No se ha podido crear el grupo $grupo" >> $errores
    fi
  elif ! getent group "$grupo" > /dev/null; then
    read -rp "El gid $gid ya existe, pero el grupo $grupo no ¿Quiere crearlo con otro gid? (s/n)" c
      if [ "$c" == "s" ] || [ "$c" == "S" ]; then
        addgroup "$grupo"
        # shellcheck disable=SC2181
        if [ $? -eq 0 ]; then
          echo "Grupo '$grupo' creado." >> $aciertos
        else
          echo "Error al crear $grupo con gid puesto por el sistema"
        fi
      else
        echo "El usuario decidio no crear $grupo con gid del sistema" >> $errores
      fi
  else
    echo "El grupo '$grupo' ya existe."
  fi
done < grupos.txt

# Ejecutar el menú
menu