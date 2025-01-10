#!/usr/bin/bash

# Exécute un conteneur Docker en arrière-plan
container_id=$(docker run --rm -dti sae103-excel2csv)

# Vérifiez si le conteneur a démarré correctement
if [ -z "$container_id" ]; then
    echo "Erreur: Impossible de démarrer le conteneur Docker."
    exit 1
fi

shopt -s nullglob  # Ignore les globs sans correspondance
# Conversion des fichiers XLSX en CSV
for file in *.xlsx; do
    docker cp "$file" "${container_id}:/tmp/${file}"
    docker exec "${container_id}" ssconvert "/tmp/${file}" "/tmp/${file%.xlsx}.csv"
    docker cp "${container_id}:/tmp/${file%.xlsx}.csv" "${file%.xlsx}.csv"
done

# Vérifiez si le conteneur est toujours en cours d'exécution avant de l'arrêter
if docker ps -q --filter "id=${container_id}" | grep -q .; then
    docker stop "${container_id}"
else
    echo "Erreur: Le conteneur Docker n'est plus en cours d'exécution."
fi

# Conversion des fichiers CSV en HTML
for csv_file in *.csv; do
    html_file="${csv_file%.csv}.html"
    awk -F',' 'BEGIN {print "<table>"} 
        NR==1 {print "<tr>"; for(i=1; i<=NF; i++) print "<th>"$i"</th>"; print "</tr>"} 
        NR>1 {print "<tr>"; for(i=1; i<=NF; i++) print "<td>"$i"</td>"; print "</tr>"} 
        END {print "</table>"}' "$csv_file" > "$html_file"
done