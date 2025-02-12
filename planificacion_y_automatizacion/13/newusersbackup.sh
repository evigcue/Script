#!/bin/bash

# Comprobamos que el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root."
    exit 1
fi

# Comprobamos si tenemos un fichero con los usuarios actuales.
# La primera vez que ejecutamos el script crearemos copia de todos los usuarios que ya tengamos.

if [ ! -f ./users.txt ]; then
    touch ./users.txt
    echo "Se ha creado el fichero users.txt" >> /var/log/newusers.log
fi

cat /etc/passwd | grep "/bin/bash" | cut -d ':' -f 1 > /tmp/users.txt

for user in cat$(/tmp/users.txt); do
    exist=$( grep "$user" ./users.txt | wc -l )
    if [ $exist -eq 0 ]; then
        tar -czf "/backup/$user.tar.gz" "/home/$user"
        echo "Se ha creado un backup de $user" >> /var/log/newusers.log
        echo "$user" >> ./users.txt
    else
        echo "El usuario $user ya existe, no se le ha hecho backup" >> /var/log/newusers.log
    fi
done