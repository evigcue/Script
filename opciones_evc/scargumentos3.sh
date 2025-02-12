#!/bin/bash

# Comprobar si se pasa al menos un argumento
if [ "$#" -lt 1 ]; then
    echo "Uso: $0 <usuario> [tty]"
    exit 1
fi

# Asignar los argumentos a variables
usuario=$1
tty=${2:-}

# Verificar si el usuario está conectado
if who | grep -q "^$usuario"; then
    echo "El usuario '$usuario' está conectado."
    
    # Obtener procesos activos del usuario
    if [ -n "$tty" ]; then
        # Si se proporciona un TTY, filtrar por este
        ps -u "$usuario" -o pid,tty,comm | grep "$tty" > "procesos_${usuario}.log"
    else
        # Sin TTY, capturar todos los procesos del usuario
        ps -u "$usuario" -o pid,tty,comm > "procesos_${usuario}.log"
    fi

    echo "Se ha generado el archivo 'procesos_${usuario}.log' con los procesos activos del usuario."

    # Controlamos que el script se ejecuta como root
    if [ "$EUID" -ne 0 ]; then
        echo "Para matar los procesos debes ser root."
        exit 1
    else
        # Confirmar si desea matar procesos uno por uno
        while IFS= read -r linea; do
            pid=$(echo "$linea" | awk '{print $1}')
            nombre_proceso=$(echo "$linea" | awk '{print $3}')

            echo "¿Desea matar el proceso $pid ($nombre_proceso)? [s/N]"
            read -r respuesta
            if [[ "$respuesta" =~ ^[sS]$ ]]; then
                kill "$pid" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "Proceso $pid ($nombre_proceso) terminado."
                else
                    echo "No se pudo terminar el proceso $pid ($nombre_proceso)."
                fi
            else
                echo "El proceso $pid ($nombre_proceso) no se ha terminado."
            fi
        done < "procesos_${usuario}.log"
    fi
else
    echo "El usuario '$usuario' no está conectado."
fi