#!/bin/bash

# Verifica si se proporciona un usuario como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <nombre_usuario>"
    exit 1
fi

USER=$1

# Verifica el espacio disponible en la cuota del usuario
QUOTA_INFO=$(quota -u "$USER" | tail -n 1)
if [ $? -ne 0 ]; then
    echo "Error: No se pudo obtener información de la cuota para el usuario $USER."
    exit 1
fi

# Extrae el límite de bloques (hard limit) y el uso actual del usuario
BLOCK_SIZE=1024 # Tamaño de bloque (en KB)
USAGE=$(echo "$QUOTA_INFO" | awk '{print $2}')
LIMIT=$(echo "$QUOTA_INFO" | awk '{print $3}')

# Valida que los valores obtenidos sean números
if ! [[ "$USAGE" =~ ^[0-9]+$ ]] || ! [[ "$LIMIT" =~ ^[0-9]+$ ]]; then
    echo "Error: No se pudo interpretar la información de cuota."
    exit 1
fi

# Calcula el espacio restante en bloques
REMAINING_BLOCKS=$((LIMIT - USAGE))

if [ "$REMAINING_BLOCKS" -le 0 ]; then
    echo "El usuario $USER ya alcanzó su límite de cuota."
    exit 0
fi

# Crea un archivo temporal para llenar el espacio disponible
TMP_DIR=$(sudo -u "$USER" mktemp -d)
TMP_FILE="$TMP_DIR/fill_quota.tmp"

echo "Llenando el espacio en disco para el usuario $USER..."
sudo -u "$USER" dd if=/dev/zero of="$TMP_FILE" bs=$BLOCK_SIZE count=$REMAINING_BLOCKS status=progress

if [ $? -eq 0 ]; then
    echo "El espacio disponible para el usuario $USER ha sido llenado."
else
    echo "Error al intentar llenar el espacio en disco."
fi

# Opción para limpiar el archivo temporal si es necesario
echo "¿Deseas eliminar el archivo temporal creado? (s/n)"
read -r RESPONSE
if [[ "$RESPONSE" =~ ^[sS]$ ]]; then
    rm -f "$TMP_FILE"
    rmdir "$TMP_DIR"
    echo "Archivo temporal eliminado."
else
    echo "Archivo temporal preservado en $TMP_FILE."
fi

exit 0