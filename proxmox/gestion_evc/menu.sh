#!/bin/bash
function menu {
    while true; do
        echo "----- MENÚ -----"
        echo "1. Crear Pool";
        echo "2. Listar Pools";
        echo "3. Crear usuario Proxmox";
        echo "4. Listar usuarios Proxmox";
        echo "5. Asignar usuario a Pool";
        echo "6. Listar Pools de los usuarios";
        echo "7. Crear Plantilla de una MV";
        echo "8. Crear Clonación sobre Plantilla";
        echo "9. Crear copia de seguridad de una MV";
        echo "10. Crear copia de seguridad de una Pool";
        echo "11. Listar copias de seguridad de una Pool";
        echo "12. Listar copias de seguridad de un usuario concreto";
        echo "13. Salir";
        # shellcheck disable=SC2162
        read -p "Elige una opción: " opcion

        case $opcion in
            1) crear_pool ;;
            2) listar_pools ;;
            3) crear_usuario ;;
            4) listar_usuarios ;;
            5) asignar_pool ;;
            6) listar_pools_usuarios ;;
            7) crear_plantilla ;;
            8) clonar_plantilla ;;
            9) crear_copia ;; # Por alguna razón este código no está
            10) crear_copia_pool ;;
            11) listar_copia_pool ;;
            12) listar_copia_usuario ;;
            13) exit ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

function crear_pool {
    read -p "Introduce el nombre para la pool: " pool
    pvesh create pools -poolid $pool
}

function listar_pools {
    pvesh get /pools
}

function crear_usuario {
    read -p "Introduce el nombre para el user: " user
    read -p "Introduce el password para el user: " passwd
    pveum useradd "$user@pve" --password "$passwd"
}

function listar_usuarios {
    pveum user list
}

function asignar_pool {
    read -p "Introduce el pool: " pool
    read -p "Introduce el user: " user
    pveum aclmod /pool/"$pool" --user "$user@pve" --roles PVEPoolUser
}

function listar_pools_usuarios {
    read -p "Introduce el user: " user
    pvesh get /pools | grep "$user"
}

function crear_plantilla {
    read -p "Introduce la id de la MV que hacer plantilla: " id
    qm template "$id"
}

function clonar_plantilla {
    read -p "Introduce la id de la MV que hacer clonación: " id
    read -rp "Introduce el id para la clonación: " newid
    read -p "Introduce el nombre para la clonación: " nombre
    read -p "Introduce la pool para la clonación: " pool
    qm clone "$id" "$newid" --name "$nombre" --pool "$pool"
}

function crear_copia {
    backup_dir="/var/lib/vz/dump"
    read -p "Introduce la id de la MV que hacer copia de seguridad: " id
    vzdump "$id" --mode snapshot
}

function crear_copia_pool {
    # Solo hace copia de la primera máquina, no de todas.
    # Cada máquina ocupa dos líneas, puedo hacer un wc -l para sacar el total de máquinas y hacer un for de las máquinas con un cut para quedarme con
    # las líneas de cada máquina. Head + tail no sirve porque es una sola línea.
    read -p "Introduce el nombre de la Pool que hacer copia de seguridad: " pool
    # read -p "Introduce el nombre para la copia de seguridad: " nombre
    vmids=$(pvesh get /pools/"$pool" | grep -o 'qemu/[0-9]*' | awk -F/ '{print $2}')
    # Verifica si la pool contiene máquinas virtuales
    if [ -z "$vmids" ]; then
        echo "La pool '$pool' no contiene máquinas virtuales."
        exit 1
    fi
    backup_dir="/var/lib/vz/dump"
    # Crea copias de seguridad para cada VM en la pool
    echo "Iniciando copias de seguridad para la pool '$pool'..."
    for vmid in $vmids; do
        echo "Creando copia de seguridad para VM ID: $vmid..."
        vzdump "$vmid" --dumpdir "$backup_dir" --mode snapshot
    done
    echo "Copias de seguridad completadas. Archivos almacenados en: $backup_dir"
}

function listar_copia_pool {
    read -p "Introduce el nombre de la Pool: " pool
    backup_dir="/var/lib/vz/dump"  # Ruta donde se guardan las copias de seguridad
    vmids=$(pvesh get /pools/"$pool" | grep -o 'qemu/[0-9]*' | awk -F/ '{print $2}')
    for vmid in $vmids ; do
        echo "Copias de seguridad para VM $vmid:"
        ls -l $backup_dir | grep "vzdump-qemu-$vmid"
    done
}

function listar_copia_usuario {
    read -p "Introduce el user: " user
    backup_dir="/var/lib/vz/dump"
    for vmid in $(pvesh get /access/permissions --user "$user@pve" | grep "VM.Backup" | awk '{print $2}' | awk -F/ '{print $3}'); do
        echo "Copias de seguridad para VM $vmid:"
        ls -l $backup_dir | grep "vzdump-qemu-$vmid"
    done

}

menu