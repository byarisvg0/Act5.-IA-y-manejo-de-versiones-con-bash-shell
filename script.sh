

#!/bin/bash

# Integrante 1: Validar los datos de entrada

# 1. Verificar que se reciban exactamente 2 argumentos
if [ "$#" -ne 2 ]; then
    echo "Error: Debes proporcionar exactamente 2 argumentos."
    echo "Uso: ./buscar.sh \"palabra_a_buscar\" \"ruta_de_la_carpeta\""
    exit 1
fi

# 2. Guardar los argumentos en variables
palabra="$1"
ruta="$2"

# 3. Verificar que la ruta exista y sea un directorio
if [ ! -d "$ruta" ]; then
    echo "Error: La ruta no existe o no es un directorio válido."
    exit 1
fi

# 4. Verificar que la palabra no esté vacía
if [ -z "$palabra" ]; then
    echo "Error: La palabra o frase no puede estar vacía."
    exit 1
fi

# 5. Buscar la palabra en los archivos de la carpeta
echo "Buscando: $palabra"
echo "Carpeta: $ruta"

grep -r -I -o -F -- "$palabra" "$ruta" 2>/dev/null |
    awk -F: '{
        archivo = $1
        frecuencia[archivo]++
    }
    END {
        if (length(frecuencia) == 0) {
            print "No se encontraron coincidencias."
        } else {
            for (archivo in frecuencia) {
                print "Archivo: " archivo
                print "Frecuencia: " frecuencia[archivo]
                print ""
            }
        }
    }'

