#!/usr/bin/env python3

import sys # Módulo para trabajar con la entrada y salida estándar
import os # Módulo para ejecutar comandos del sistema operativo
import grp # Módulo para trabajar con grupos de usuarios

'''
def user_exists(username):
    # Comprueba si un usuario existe en /etc/passwd.
    try:
        with open("/etc/passwd", "r") as archivo: # Abre el archivo en modo lectura de forma segura (se cierra automáticamente)
            for line in archivo:
                if line.split(":")[0] == username:
                    return True
        return False
    except FileNotFoundError:
        print("Error: No se encontró el archivo /etc/passwd")
        sys.exit(1)
'''

'''
def show_groups():
    # Muestra la lista de grupos del sistema.
    grupos = grp.getgrall() # Obtiene una lista de objetos de los grupos del sistema.
    print("Grupos del sistema:")
    for grupo in grupos:
        print(f"- {grupo.gr_name}") # Utiliza el atributo gr_name para obtener el nombre del grupo de la variable grupo.
        # La opción f del print pertenece a las f-strings, que permiten formatear cadenas de texto de forma más sencilla.
'''

'''
def agregar_usuario_a_grupo(username, groupname):
    # Añade un usuario a un grupo.
    try:
        os.system(f"sudo useradd -G {groupname} {username}")
        print(f"Usuario '{username}' añadido al grupo '{groupname}'.")
    except Exception as e:
        print(f"Error al añadir usuario al grupo: {e}")
'''

if len(sys.argv) != 2:
    print("Uso: python script.py <username>")
    sys.exit(1)

username = sys.argv[1]

with open("/etc/passwd", "r") as archivo: # Abre el archivo en modo lectura de forma segura (se cierra automáticamente)
        for line in archivo:
            if line.split(":")[0] == username:
                print(f"Error: El usuario '{username}' ya existe.")
                sys.exit(1)
            else:

                grupos = grp.getgrall()

                print("Grupos del sistema:")
                
                for grupo in grupos:
                    print(f"- {grupo.gr_name}")
                
                groupname = input("Elige un grupo al que añadir el usuario: ")

                try:
                    os.system(f"sudo useradd -G {groupname} {username}")
                    print(f"Usuario '{username}' añadido al grupo '{groupname}'.")
                except Exception as e:
                    print(f"Error al añadir usuario al grupo: {e}")
                    sys.exit(1)

'''
if user_exists(username):
    print(f"Error: El usuario '{username}' ya existe.")
    sys.exit(1)
else:
    show_groups()

    groupname = input("Elige un grupo al que añadir el usuario: ")

    agregar_usuario_a_grupo(username, groupname)
'''