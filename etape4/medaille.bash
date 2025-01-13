#!/bin/bash

INPUT_FILE="Tableau des médailles v2.csv"
TEMP_CSV="medals.csv"
OUTPUT_FILE="Tableau médailles.csv"

# Supprimer les lignes inutiles
tail -n +4 "$INPUT_FILE" > temp_no_headers.csv

# Calculer les totaux et trier
awk -F',' '{
    total = $2 + $3 + $4
    print $1 "," $2 "," $3 "," $4 "," $5 "," total
}' temp_no_headers.csv | sort -t ',' -k2,2nr -k3,3nr -k4,4nr -k1,1 > sorted.csv

# Calculer le total global des médailles
total_medailles=$(awk -F',' '{sum+=$6} END {print sum}' sorted.csv)

# Ajouter le classement, le total des médailles du pays, et le pourcentage des médailles
awk -F',' -v total_medailles="$total_medailles" '{
    if ($6 == prev_total && $3 == prev_gold && $4 == prev_silver && $5 == prev_bronze) {
        print "-," $0
    } else {
        rank++
        percentage = ($6 / total_medailles) * 100
        printf "%d,%s,%s,%s,%s,%s,%.0f,%.2f%%\n", rank, $1, $2, $3, $4, $5, $6, percentage
    }
    prev_total=$6; prev_gold=$3; prev_silver=$4; prev_bronze=$5
}' sorted.csv > "$OUTPUT_FILE"

# Nettoyage
rm -f temp_no_headers.csv sorted.csv

echo "Traitement terminé. Résultat dans : $OUTPUT_FILE"
