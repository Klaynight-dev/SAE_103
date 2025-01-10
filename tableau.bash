#!/bin/bash
INPUT_FILE="Tableau des médailles v1.xlsx"
TEMP_CSV="medals.csv"
OUTPUT_FILE="processed_medals.csv"

# Supprimer le titre et les en-têtes
tail -n +4 "$TEMP_CSV" > "Tableau des médailles v2.csv"

# Calculer les totaux et trier
awk -F',' '{
    total = $3 + $4 + $5
    print $1 "," $2 "," $3 "," $4 "," $5 "," total
}' "Tableau des médailles v2.csv" | sort -t ',' -k3,3nr -k4,4nr -k5,5nr -k1,1 > sorted.csv

# Ajouter le classement
awk -F',' '{
    if ($6 == total && $3 == or && $4 == argent && $5 == bronze) {
        print "-," $0
    } else {
        rang++
        print rang "," $0
    }
    total=$6; or=$3; argent=$4; bronze=$5
}' sorted.csv > "$OUTPUT_FILE"