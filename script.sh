#!/bin/bash
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
