#!/bin/bash

# Variables
TEAM_NAME="nom_équipe"
OUTPUT_DIR="etape4"
HTML_FILE="${OUTPUT_DIR}/index.html"
PDF_FILE="${OUTPUT_DIR}/tableau_medailles.pdf"
DOCKER_IMAGE="docker.io/bigpapoo/sae103-html2pdf"
CSV_FILE="/mnt/c/Users/Elouan/Documents/IUT/SAE 1.03/your_csvfile.csv"  # Update this path

# Vérifier si le répertoire de sortie existe, sinon le créer
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Générer le fichier HTML (vous devez adapter cette partie selon vos besoins)
cat <<EOF > $HTML_FILE
<!DOCTYPE html>
<html lang="fr">
<head>
        <meta charset="UTF-8">
        <title>Tableau des Médailles</title>
        <style>
                body { font-family: Arial, sans-serif; }
                table { width: 100%; border-collapse: collapse; }
                th, td { border: 1px solid black; padding: 8px; text-align: center; }
                th { background-color: #f2f2f2; }
                img { width: 20px; height: auto; }
        </style>
</head>
<body>
        <h1>Tableau des Médailles - JO Paris 2024</h1>
        <img src="logo_jo_paris_2024.png" alt="Logo JO Paris 2024">
        <table>
            <tr>
                <th>Classement</th>
                <th>Pays</th>
                <th>Or</th>
                <th>Argent</th>
                <th>Bronze</th>
                <th>Total</th>
                <th>Pourcentage</th>
            </tr>
            $(awk -F',' 'NR>1 { printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4, $5, $6, $7 }' $CSV_FILE)
        </table>
</body>
</html>
EOF

# Utiliser Docker pour convertir le HTML en PDF
podman run --rm -v "$(pwd)/${OUTPUT_DIR}:/data" ${DOCKER_IMAGE} weasyprint /data/index.html /data/tableau_medailles.pdf

# Créer une archive zip contenant le répertoire etape4
zip -r "etape4-${TEAM_NAME}.zip" "$OUTPUT_DIR"