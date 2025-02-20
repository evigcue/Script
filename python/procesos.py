import subprocess

subprocess.run(["ps", "-aux"])
PID = input("¿Qué proceso quiere terminar? ") # Pide al usuario el PID del proceso que desea terminar
try:
    int(PID) # Comprueba si el PID es un número
except ValueError:
    print("Error: El PID debe ser un número.")
    exit(1)

try:
    subprocess.run(["kill", "-0", PID]) # Comprueba si el proceso existe
except subprocess.CalledProcessError:
    print("Error: El proceso no existe.") # Capturar el error que nos da el comando kill
    exit(1)

method = input("¿Quiere forzar la detención o mandar una petición de finalización? (f/p) ")
if method == "f":
    try:
        subprocess.run(["kill", "-9", PID]) # Fuerza la detención del proceso
    except subprocess.CalledProcessError:
        print("Error: No se pudo forzar la detención del proceso.")
        exit(1)
else:
    subprocess.run(["kill", PID])