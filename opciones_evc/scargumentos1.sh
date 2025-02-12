#!/bin/bash

log=/var/log/opciones.log

# Verifica si se pasa una opción
if [ $# -lt 2 ]; then
    echo "Uso: $0 -x|-a|-c|-v <fichero.tar>"
    exit 1
fi

fichero=""

while getopts x:a:c:v opt; do
    case ${opt} in
        x) fichero=$OPTARG 
            archivo=$(find / -name "$fichero" 2>/dev/null)

            # Verificar si se ha encontrado el archivo
            if [ -z "$archivo" ]; then
                echo "Error: El archivo $fichero no fue encontrado en el sistema." >> $log
                exit 1
            else
                echo "Archivo encontrado en: $archivo" >> $log
                echo "Descomprimiendo $archivo en la carpeta actual..." >> $log
                tar -xf "$archivo"  # Descomprimir el archivo tar
                if [ $? -eq 0 ]; then
                    echo "Descomprimido exitosamente." >> $log
                else
                    echo "Error al descomprimir el archivo." >> $log
                    exit 1
                fi
            fi
        ;;
        a) fichero=$OPTARG
            # Verificar si el archivo tar ya existe
            if [ ! -e "$fichero" ]; then
                echo "El archivo tar $fichero no existe. Creando uno nuevo..." | tee -a $log
                tar -cf "$fichero" /dev/null  # Crear el archivo tar vacío si no existe
            fi

            # Añadir archivos .txt al archivo tar
            find / -type f -name "*.txt" -exec tar -rf "$fichero" {} \; 2>$log
            if [ $? -eq 0 ]; then
                echo "Archivos .txt añadidos exitosamente a $fichero." | tee -a $log
            else
                echo "Error al añadir los archivos .txt." | tee -a $log
                exit 1
            fi
        ;;
        c) fichero=$OPTARG
            echo "Creando $fichero con los archivos del directorio HOME..."
            tar -cf "$fichero" "$HOME"
            if [ $? -eq 0 ]; then
                echo "Archivo tar creado exitosamente." >> $log
            else
                echo "Error al crear el archivo tar." >> $log
                exit 1
            fi
        ;;
        v) fichero=$OPTARG
            if [ -e "$fichero" ]; then
                echo "Contenido de $fichero: " | tee $log
                echo "Extrayendo $fichero..." | tee $log
                tar -tf "$fichero"
                if [ $? -eq 0 ]; then
                    echo "Extraccion exitosa." >> $log
                else
                    echo "Error al extraer el archivo $fichero." | tee $log
                    exit 1
                fi
            else
                echo "Error: El archivo $fichero no existe." | tee $log
            fi
        ;;
        *) echo "Opcion no valida" ;;
    esac
done