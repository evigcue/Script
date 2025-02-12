#!/bin/bash

log=/var/log/opciones.log

# El getopts de abajo sustituiría a lo anterior de forma más óptima
while getopts "D:x:a:c:v" opt; do
    case $opt in
        D)
            dir=$OPTARG
            ;;
        x)
            fichero=$OPTARG
            op="x"
            ;;
        a)
            fichero=$OPTARG
            op="a"
            ;;
        c)
            fichero=$OPTARG
            op="c"
            ;;
        v)
            fichero=$OPTARG
            echo $fichero
            op="v"
            ;;
        *)
            echo "Opcion no valida"
            exit 1
            ;;
    esac
done

# Verifica si se pasa una opción
if [ $# -lt 2 ]; then
    echo "Uso: $0 -x|-a|-c|-v <fichero.tar> [-D <directorio>] o $0 [-D <directorio>] -x|-a|-c|-v <fichero.tar>"
    exit 1
elif [ $# -eq 4 ]; then
    if [ "$1" == "-D" ]; then
        dir=$2
        op=$3
        fichero=$4
    elif [ "$3" == "-D" ]; then
        dir=$4
        op=$1
        fichero=$2
    else
        echo "Opciones escritas en el orden incorrecto."
        echo "Uso: $0 -x|-a|-c|-v <fichero.tar> [-D <directorio>] o $0 [-D <directorio>] -x|-a|-c|-v <fichero.tar>"
        exit 1
    fi
elif [ $# -eq 2 ]; then
    op=$1
    fichero=$2
fi


echo "Opcion escogida: $op" > /dev/null
echo "Fichero escogido: $fichero" > /dev/null

if [ ! -e "$dir" ]; then
    dir=.
    echo "No se ha escogido directorio. Se usara el directorio actual: $dir" | tee $log
else
    echo "Directorio escogido: $dir" > $log
    if [ ! -d "$dir" ]; then
        echo "El directorio escogido no existe." | tee $log
        echo "Se va a crear el directorio: $dir" | tee $log
        mkdir -p "$dir"
        if [ $? -eq 0 ]; then
            echo "Directorio creado exitosamente." | tee $log
        else
            echo "Error al crear el directorio." | tee $log
            echo "Se usara el directorio actual." | tee $log
            dir=.
        fi
        exit 1
    fi
fi

# Cambiar el if por un case.
if [ "$op" == "x" ] || [ "$op" == "-x" ]; then 
    # archivo=$(find "$dir" -name "$fichero" 2>/dev/null)

    # Verificar si se ha encontrado el archivo
    if [ ! -e "$dir/$fichero" ]; then
        echo "Error: El archivo $fichero no fue encontrado en el sistema." | tee $log
        exit 1
    else
        echo "Archivo encontrado en: $dir/$fichero" | tee $log
        echo "Descomprimiendo $fichero en la carpeta actual..." | tee $log
        tar -xf "$fichero" -C "$dir"
        if [ $? -eq 0 ]; then
            echo "Descomprimido exitosamente." | tee $log
        else
            echo "Error al descomprimir el archivo." | tee $log
            exit 1
        fi
    fi
elif [ "$op" == "a" ] || [ "$op" == "-a" ]; then
    # Verificar si el archivo tar ya existe
    if [ ! -e "$dir/$fichero" ]; then
        echo "El archivo tar $fichero no existe. Creando uno nuevo..." | tee -a $log
        tar -cf "$dir/$fichero" /dev/null  # Crear el archivo tar vacío si no existe
    fi

    # Añadir archivos .txt al archivo tar
    find / -type f -name "*.txt" -exec tar -rf "$dir/$fichero" {} \; 2>$log
    if [ $? -eq 0 ]; then
        echo "Archivos .txt añadidos exitosamente a $fichero." | tee -a $log
    else
        echo "Error al añadir los archivos .txt." | tee -a $log
        exit 1
    fi
elif [ "$op" == "c" ] || [ "$op" == "-c" ]; then
    echo "Creando $fichero con los archivos del directorio HOME..."
    tar -cf "$dir/$fichero" "$HOME"
    if [ $? -eq 0 ]; then
        echo "Archivo tar creado exitosamente." | tee $log
    else
        echo "Error al crear el archivo tar." | tee $log
        exit 1
    fi
elif [ "$op" == "v" ] || [ "$op" == "-v" ]; then
    if [ -e "$dir/$fichero" ]; then
        echo "Contenido de $fichero: " | tee $log
        echo "Visualizando $fichero..." | tee $log
        tar -tf "$dir/$fichero"
        if [ $? -eq 0 ]; then
            echo "Extraccion exitosa." | tee $log
        else
            echo "Error al extraer el archivo $fichero." | tee $log
            exit 1
        fi
    else
        echo "Error: El archivo $fichero no existe en $dir." | tee $log
        echo "Buscando en por $fichero en el equipo." | tee $log
        find / -name "$fichero" -exec tar -tf {} \; 2>/dev/null
    fi
fi