#!/bin/bash
# Uso: ./script.sh "palabra o frase" /ruta/a/carpeta

# ===== Validación de argumentos =====
if [ "$#" -ne 2 ]; then
    echo "Uso incorrecto: se necesitan exactamente 2 argumentos." >&2
    echo "Uso: $0 \"palabra o frase\" /ruta/a/carpeta" >&2
    exit 1
fi

PALABRA="$1"
RUTA="$2"

if [ -z "$PALABRA" ]; then
    echo "Error: la palabra o frase a buscar no puede estar vacía." >&2
    exit 1
fi

if [ ! -e "$RUTA" ]; then
    echo "Error: la ruta '$RUTA' no existe." >&2
    exit 2
fi

if [ ! -d "$RUTA" ]; then
    echo "Error: '$RUTA' existe, pero no es un directorio." >&2
    exit 2
fi

# ===== Búsqueda recursiva =====
# -r recursivo, -l solo nombres de archivo, -F texto literal, -I ignora binarios
ARCHIVOS=$(grep -rlIF -- "$PALABRA" "$RUTA" 2>/dev/null)

if [ -z "$ARCHIVOS" ]; then
    echo "No se encontró \"$PALABRA\" en ningún archivo de $RUTA."
    exit 0
fi

# Provisional: la parte de formato y conteo reemplaza esto
echo "$ARCHIVOS"
