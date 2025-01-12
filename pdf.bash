#!/bin/bash
INPUT_FILE="Tableau des médailles.csv"
OUTPUT_HTML="Tableau des médailles.html"
OUTPUT_PDF="Tableau des médailles.pdf"

# Générer le HTML
echo "<html><head><title>Médailles</title></head><body>" > "$OUTPUT_HTML"
echo "<h1>Classement des Médailles - JO Paris 2024</h1>" >> "$OUTPUT_HTML"
echo "<table>" >> "$OUTPUT_HTML"
awk -F',' 'NR>1 {
    printf "<tr><td><img src=\"flags/20px/%s.png\"></td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>", $2, $1, $3, $4, $5, $6
}' "$INPUT_FILE" >> "$OUTPUT_HTML"
echo "</table></body></html>" >> "$OUTPUT_HTML"

# Convertir en PDF
docker run --rm -v "$(pwd)":/data -w /data sae103-html2pdf weasyprint "$OUTPUT_HTML" "$OUTPUT_PDF"
