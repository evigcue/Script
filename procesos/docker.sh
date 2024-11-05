#!/bin/bash

log=/var/log/dockersh.log

function menu {
    while true; do
        echo "1. Mostrar estado de los servicios"
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
            2) sudo docker ps ;;
            3) sudo docker ps -a ;;
            4) sudo docker images ;;
            5) sudo docker network ls ;;
            6) sudo docker volume ls ;;
            7) read -p "Ingrese el nombre o ID del contenedor a apagar: " contenedor
               sudo docker stop "$contenedor" 
               if [ $? -eq 0 ]; then
                echo "Contenedor $contenedor apagado" | tee $log
               else
                echo "Error al apagar el contenedor $contenedor" | tee $log
               fi ;;
            8) sudo docker stop $(sudo docker ps -aq) 
                if [ $? -eq 0 ]; then
                    echo "Todos los contenedores apagados" | tee $log
                else
                    echo "Error al apagar los contenedores" | tee $log
                fi ;;
            9) read -p "Ingrese el nombre o ID del contenedor a eliminar: " contenedor
               sudo dicker stop "$contenedor"
               if [ $? -eq 0 ]; then
                echo "Contenedor $contenedor apagado" | tee $log
               else
                echo "Error al apagar el contenedor $contenedor" | tee $log
               fi
               sudo docker rm "$contenedor" 
               if [ $? -eq 0 ]; then
                echo "Contenedor $contenedor eliminado" | tee $log
               else
                echo "Error al eliminar el contenedor $contenedor" | tee $log
               fi ;;
            10) sudo docker stop $(sudo docker ps -aq)
                if [ $? -eq 0 ]; then
                    echo "Todos los contenedores apagados" | tee $log
                else
                    echo "Error al apagar los contenedores" | tee $log
                fi
                sudo docker rm $(sudo docker ps -aq)
                if [ $? -eq 0 ]; then
                    echo "Todos los contenedores eliminados" | tee $log
                else
                    echo "Error al eliminar los contenedores" | tee $log
                fi ;;
            11) read -p "Ingrese el nombre o ID de la imagen a eliminar: " imagen
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
                fi ;;
            12) sudo docker rmi $(sudo docker images -aq) ;;
            13) exit ;;
        esac
    done
}

menu

printf "Gracias por usar el script"