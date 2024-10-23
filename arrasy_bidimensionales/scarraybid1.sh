#!/bin/bash

# Fichero donde se almacenarán los usuarios posibles
usersfile="users.txt"

# Array bidimensional para almacenar usuarios
declare -A usuarios

# Cargar usuarios desde el fichero en el array bidimensional
function cargar_usuarios {
    if [ -f "$usersfile" ]; then
        while IFS=: read -r nombre uid gid home shell; do
            usuarios["$nombre,uid"]=$uid
            usuarios["$nombre,gid"]=$gid
            usuarios["$nombre,home"]=$home
            usuarios["$nombre,shell"]=$shell
        done < "$usersfile"
    fi
}

# Guardar usuarios desde el array al fichero
function save_user {
    true > "edited_users.txt"
    for key in "${!usuarios[@]}"; do
        IFS=, read -r nombre campo <<< "$key"
        if [ "$campo" == "uid" ]; then
            echo "$nombre:${usuarios[$nombre,uid]}:${usuarios[$nombre,gid]}:${usuarios[$nombre,home]}:${usuarios[$nombre,shell]}" >> "$usersfile"
        fi
    done
}

# Crear un nuevo usuario
function create_user {
    # shellcheck disable=SC2162
    read -p "Introduce el nombre de usuario: " nombre

    # -n comprueba si el valor es no nulo, si contiene información será true y si no la tiene será false
    if [ -n "${usuarios[$nombre,uid]}" ]; then
        echo "El usuario $nombre ya existe."
        echo
        return
    fi

    # shellcheck disable=SC2162
    read -p "Introduce el UID: " uid
    # shellcheck disable=SC2162
    read -p "Introduce el GID: " gid
    # shellcheck disable=SC2162
    read -p "Introduce el directorio HOME: " home
    # shellcheck disable=SC2162
    read -p "Introduce el shell: " shell

    usuarios["$nombre,uid"]=$uid
    usuarios["$nombre,gid"]=$gid
    usuarios["$nombre,home"]=$home
    usuarios["$nombre,shell"]=$shell

    echo "Usuario $nombre creado con éxito."
}

# Modificar un usuario existente
function modify_user {
    read -rp "Introduce el nombre de usuario a modificar: " nombre

    # Si la cadena está vacía devuelve true
    if [ -z "${usuarios[$nombre,uid]}" ]; then
        echo "El usuario $nombre no existe."
        # shellcheck disable=SC2162
        read -p "¿Quiere crearlo? (s/n): " ans
        if [ "$ans" == "s" ] || [ "$ans" == "S" ]; then
            create_user
            return
        else
            echo
            return
        fi
    fi

    read -rp "¿Qué campo quieres modificar? (uid/gid/home/shell): " campo
    if [[ "$campo" =~ ^(uid|gid|home|shell)$ ]]; then
        read -rp "Introduce el nuevo valor para $campo: " valor
        usuarios["$nombre,$campo"]=$valor
        echo "Usuario $nombre modificado con éxito."
    else
        echo "Campo no válido."
    fi
}

# Borrar un usuario
function delete_user {
    read -rp "Introduce el nombre de usuario a borrar: " nombre
    
    # Si la cadena está vacía devuelve true
    if [ -z "${usuarios[$nombre,uid]}" ]; then
        echo "El usuario $nombre no existe."
        echo
        return
    fi

    for campo in uid gid home shell; do
        # shellcheck disable=SC2086
        unset "usuarios["$nombre,$campo"]"
    done
    echo "Usuario $nombre borrado con éxito."
}

# Ver datos de un usuario
function see_user {
    read -rp "Introduce el nombre de usuario a ver: " nombre

    # Si la cadena está vacía devuelve true
    if [ -z "${usuarios[$nombre,uid]}" ]; then
        echo "El usuario $nombre no existe."
        echo
        return
    fi

    echo "Datos del usuario $nombre:"
    echo "UID: ${usuarios[$nombre,uid]}"
    echo "GID: ${usuarios[$nombre,gid]}"
    echo "HOME: ${usuarios[$nombre,home]}"
    echo "SHELL: ${usuarios[$nombre,shell]}"
}

# Volcar los nuevos usuarios al fichero /etc/passwd
function volcar_a_passwd {
    for key in "${!usuarios[@]}"; do
        IFS=, read -r nombre campo <<< "$key"
        if [ "$campo" == "uid" ] && ! grep -q "^$nombre:" /etc/passwd; then
            echo "$nombre:x:${usuarios[$nombre,uid]}:${usuarios[$nombre,gid]}::${usuarios[$nombre,home]}:${usuarios[$nombre,shell]}" >> /etc/passwd
            echo "Usuario $nombre añadido a /etc/passwd."
        fi
    done
}

# Menú principal
function menu {
    cargar_usuarios
    while true; do
        echo "----- MENÚ -----"
        echo "1. Crear usuario"
        echo "2. Modificar usuario"
        echo "3. Borrar usuario"
        echo "4. Ver usuario"
        echo "5. Volcar a /etc/passwd"
        echo "6. Salir"
        # shellcheck disable=SC2162
        read -p "Elige una opción: " opcion

        case $opcion in
            1) create_user ;;
            2) modify_user ;;
            3) delete_user ;;
            4) see_user ;;
            5) volcar_a_passwd ;;
            6) save_user; exit ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

# Ejecutar el menú
menu