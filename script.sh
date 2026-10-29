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

# ===== Formato de salida y conteo =====
# Usa $PALABRA y $RUTA de la validación, y $ARCHIVOS (un archivo por línea) del motor de búsqueda
if [ -z "$ARCHIVOS" ]; then
    ARCHIVOS=$(grep -rlIF -- "$PALABRA" "$RUTA" 2>/dev/null)
fi

if [ -z "$ARCHIVOS" ]; then
    echo "No se encontró \"$PALABRA\" en ningún archivo de $RUTA."
    exit 0
fi

LINEA="------------------------------------------------------------"
TOTAL=0
NUM_ARCHIVOS=0
RESULTADOS=""

# Cuenta cada aparición (no solo las líneas) con grep -o
while IFS= read -r archivo; do
    VECES=$(grep -oF -- "$PALABRA" "$archivo" | wc -l | tr -d ' ')
    if [ "$VECES" -gt 0 ]; then
        RESULTADOS+="$VECES"$'\t'"$archivo"$'\n'
        TOTAL=$((TOTAL + VECES))
        NUM_ARCHIVOS=$((NUM_ARCHIVOS + 1))
    fi
done <<< "$ARCHIVOS"

echo
echo "Resultados para \"$PALABRA\" en $RUTA"
echo "$LINEA"
printf "%6s  %s\n" "Veces" "Archivo"
echo "$LINEA"
# Ordena de más a menos apariciones
printf "%s" "$RESULTADOS" | sort -t$'\t' -k1,1nr | while IFS=$'\t' read -r veces archivo; do
    printf "%6s  %s\n" "$veces" "$archivo"
done
echo "$LINEA"
echo "Total: $TOTAL apariciones en $NUM_ARCHIVOS archivo(s)"
