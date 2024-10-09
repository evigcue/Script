#!/bin/bash

# Nombre del archivo de entrada
archivo_grupos="grupos.txt"

# Función para crear un grupo
crear_grupo() {
  local gid="$1"
  local group="$2"

  # Crear el grupo
  groupadd -g "$gid" "$group" 2>/dev/null

  # Comprobar si se ha creado correctamente
  if [ $? -eq 0 ]; then
    echo "$gid:$group creado correctamente" >> "grupos.log"
  else
    echo "$gid:$group ERROR: No se pudo crear" >> "errores.log"
  fi
}

# Leer el archivo de grupos y crear los grupos
while IFS=':' read -r gid nombre; do
  # Comprobar si el grupo ya existe
  if getent group "$gid" > /dev/null; then
    echo "$gid ya existe"
    echo "Quiere crear $group con otro gid? (s/n)" $crear
    if $crear = "s"; then
        groupadd "$group"
    else
        echo "No se ha creado el grupo $group"
        echo "El usuario no quiso crear el grupo $group con un gid puesto por el sistema" >> "errores.log"
    fi
  else
    crear_grupo "$gid" "$nombre"
  fi
done < "$archivo_grupos"

# Indicar que el proceso ha finalizado
echo "Proceso finalizado. Verifica los archivos de registro."