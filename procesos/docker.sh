#!/bin/bash

log=/var/log/dockersh.log

# Comprobamos si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

function menu {
    while true; do
        echo "1. Mostrar estado del servicio"
        echo "2. Mostrar contenedores en ejecución"
        echo "3. Mostrar todos los contenedores"
        echo "4. Mostrar imágenes"
        echo "5. Mostrar redes"
        echo "6. Mostrar volúmenes"
        echo "7. Apagar un contenedor"
        echo "8. Apagar todos los contenedores"
        echo "9. Eliminar un contenedor"
        echo "10. Eliminar todos los contenedores"
        echo "11. Eliminar una imagen"
        echo "12. Eliminar todas las imágenes"
        echo "13. Salir"

        read -p "Seleccione una opción: " opcion

        case $opcion in
            1) sudo systemctl status docker ;;
            2) sudo docker ps | awk 'BEGIN {print "Dockers activos: "} {print $7, $1, $2, $6} END {print "--- Fin de la lista ---"}' ;;
            3) sudo docker ps -a | awk 'BEGIN {print "Dockers activos: "} {print $7, $5, $1, $2, $6} END {print "--- Fin de la lista ---"}' ;;
            4) sudo docker images ;;
            5) sudo docker network ls ;;
            6) sudo docker volume ls ;;
            7) shutdown_container ;;
            8) shutdown_all_container ;;
            9) delete_container ;;
            10) delete_all_container ;;
            11) delete_image ;;
            12) delete_all_image ;;
            13) exit ;;
        esac
    done
}

function shutdown_container {
    read -p "Ingrese el nombre o ID del contenedor a apagar: " contenedor
    sudo docker stop "$contenedor" 
    if [ $? -eq 0 ]; then
        echo "Contenedor $contenedor apagado" | tee $log
    else
        echo "Error al apagar el contenedor $contenedor" | tee $log
    fi
}

function shutdown_all_container {
    ids=$(sudo docker ps -aq)
    for id in $ids; do
        sudo docker stop "$id"
        if [ $? -eq 0 ]; then
            echo "Contenedor $id apagado" | tee $log
        else
            echo "Error al apagar el contenedor $id" | tee $log
        fi 
    done
}

function delete_container {
    read -p "Ingrese el nombre o ID del contenedor a eliminar: " contenedor
        sudo docker stop "$contenedor"
        if [ $? -eq 0 ]; then
            echo "Contenedor $contenedor apagado" | tee $log
            sudo docker rm "$contenedor"
            if [ $? -eq 0 ]; then
                echo "Contenedor $contenedor eliminado" | tee $log
            fi
        else
            echo "Error al apagar el contenedor $contenedor" | tee $log
            echo "Probando a eliminar el contenedor $contenedor" | tee $log
            sudo docker rm "$contenedor"
            if [ $? -eq 0 ]; then
                echo "Contenedor $contenedor eliminado correctamente" | tee $log
            else
                echo "Error al eliminar el contenedor $contenedor" | tee $log
            fi
        fi
        if [ $? -eq 0 ]; then
            echo "Contenedor $contenedor eliminado" | tee $log
        else
            echo "Error al eliminar el contenedor $contenedor" | tee $log
        fi
}

function delete_all_container {
    ids=$(sudo docker ps -aq)
    for id in $ids; do
        sudo docker stop "$id"
        if [ $? -eq 0 ]; then
            echo "Contenedor $id apagado" | tee $log
        else
            echo "Error al apagar el contenedor $id" | tee $log
        fi 
    done
    if [ $? -eq 0 ]; then
        echo "Todos los contenedores apagados" | tee $log
    else
        echo "Error al apagar los contenedores" | tee $log
    fi
    for id in $ids; do
        sudo docker rm "$id"
        if [ $? -eq 0 ]; then
            echo "Contenedor $id eliminado" | tee $log
        else
            echo "Error al eliminar el contenedor $id" | tee $log
        fi 
    done
    if [ $? -eq 0 ]; then
        echo "Todos los contenedores eliminados" | tee $log
    else
        echo "Error al eliminar los contenedores" | tee $log
    fi
}

function delete_image {
    read -p "Ingrese el nombre o ID de la imagen a eliminar: " imagen
        read -p "¿Quiere eliminar la imagen aunque esté en uso? (s/n): " respuesta
        if [ "$respuesta" == "s" ]; then
            sudo docker rmi -f $imagen
            if [ $? -eq 0 ]; then
                echo "Imagen $imagen eliminada correctamente" | tee $log
            else
                echo "Error al eliminar la imagen $imagen" | tee $log
            fi
        else
            sudo docker rmi $imagen
            if [ $? -eq 0 ]; then
                echo "Imagen $imagen eliminada correctamente" | tee $log
            else
                echo "Error al eliminar la imagen $imagen, posiblemente esté en uso" | tee $log
            fi
        fi 
}

function delete_all_image {
    ids=$(sudo docker images -q)
    for id in $ids; do
        sudo docker rmi "$id"
        if [ $? -eq 0 ]; then
            echo "Imagen $id eliminada" | tee $log
        else
            echo "Error al eliminar la imagen $id" | tee $log
        fi 
    done  
}

menu

printf "Gracias por usar el script"