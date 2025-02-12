#!/bin/bash
while IFS= read -r vmid; do
    backup_dir="/var/lib/vz/dump"
    vzdump "$vmid" --dumpdir "$backup_dir" --mode snapshot
done < copias_seguridad_vm.txt