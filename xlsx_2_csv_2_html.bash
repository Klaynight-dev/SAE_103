#!/usr/bin/bash

# Exécute un conteneur Docker en arrière-plan
IMAGE="bigpapoo/sae103-excel2csvza al dz de ar am au at az bh be bw br bg ca cv cl cn cy co kp kr ci hr cu dk dm eg ec roa es us et fj fr ge gb gr gd gt hk hu in id ir ie il it jm jp jo kz ke kg xk lt my ma mx md mn no nz ug uz pk pa nl pe ph pl pr pt qa do cz ro lc rs sg sk si se ch tj tw th tn tr ua zm"
container_id=$(docker container run -dit --rm --entrypoint /bin/sh $IMAGE)

# Vérifiez si le conteneur a démarré correctement
if [ -z "$container_id" ]; then
   echo "Erreur: Impossible de démarrer le conteneur Docker."
   exit 1
fi

shopt -s nullglob  # Ignore les globs sans correspondance
# Conversion des fichiers XLSX en CSV
for file in *.xlsx; do
   docker cp "$file" "${container_id}:/tmp/${file}"
   docker exec "${container_id}" xlsx2csv "/tmp/${file}" "/tmp/${file%.xlsx}.csv"
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