#!/bin/bash
INPUT_FILE="Tableau des médailles v2.csv"
TEMP_CSV="medals.csv"
OUTPUT_FILE="Tableau médailles.csv"

# Supprimer les lignes inutiles (titre et en-têtes)
tail -n +4 "$TEMP_CSV" > temp_no_headers.csv

# Calculer les totaux et trier
awk -F',' '{
    total = $3 + $4 + $5
    print $1 "," $2 "," $3 "," $4 "," $5 "," total
}' temp_no_headers.csv | sort -t ',' -k3,3nr -k4,4nr -k5,5nr -k1,1 > sorted.csv

awk -F',' '{
    total = $<colonne_or> + $<colonne_argent> + $<colonne_bronze>
    print $1 "," $2 "," $<colonne_or> "," $<colonne_argent> "," $<colonne_bronze> "," total
}' temp_no_headers.csv

awk -F',' '{gsub(/[^0-9]/, "", $3); gsub(/[^0-9]/, "", $4); gsub(/[^0-9]/, "", $5)}1' temp_no_headers.csv > temp_cleaned.csv


# Ajouter le classement
awk -F',' '{
    if ($6 == prev_total && $3 == prev_gold && $4 == prev_silver && $5 == prev_bronze) {
        print "-," $0
    } else {
        rank++
        print rank "," $0
    }
    prev_total=$6; prev_gold=$3; prev_silver=$4; prev_bronze=$5
}' sorted.csv > "$OUTPUT_FILE"

echo "Traitement terminé. Résultat dans : $OUTPUT_FILE"