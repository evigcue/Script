#!/bin/bash

while IFS=' ' read -r gid grupo; do
  if ! getent group "$gid" > /dev/null ; then
    addgroup -g "$gid" "$grupo"
    echo "Grupo '$grupo' creado."
    echo "Grupo '$grupo' creado con gid $gid." >> nuevosgrupos.log
  elif ! getent group "$grupo" > /dev/null; then
    read -p "El gid $gid ya existe, pero el grupo $grupo no ¿Quiere crearlo con otro gid? (s/n)" c
      if [ "$c" == "s" ] || [ "$c" == "S" ]; then
        addgroup "$grupo"
        echo "Grupo '$grupo' creado." >> nuevosgrupos.log
      else
        echo "No se ha creado el grupo $grupo"
      fi
  else
    echo "El grupo '$grupo' ya existe."
  fi
done < grupos.txt
