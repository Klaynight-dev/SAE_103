#!/usr/bin/bash

# Exécute un conteneur Docker en arrière-plan
container_id=$(docker run --rm -dti sae103-excel2csv)

shopt -s nullglob  # Ignore les globs sans correspondance

# Lire le fichier de correspondance des pays et codes ISO alpha-2
declare -A country_iso_map
for file in ./flags/small/*.png; do
    filename=$(basename "$file" .png)
    country_iso_map["$filename"]="$filename"
done

# Conversion des fichiers XLSX en CSV
for file in *.xlsx; do
    docker cp "$file" "${container_id}:/tmp/${file}"
    docker exec "${container_id}" ssconvert "/tmp/${file}" "/tmp/${file%.xlsx}.csv"
    docker cp "${container_id}:/tmp/${file%.xlsx}.csv" "${file%.xlsx}.csv"
done

# Arrêter le conteneur Docker
docker stop "${container_id}"

# Préparer une chaîne pour awk++
country_iso_map_string=""
for key in "${!country_iso_map[@]}"; do
    country_iso_map_string+="$key=${country_iso_map[$key]} "
done

# Conversion des fichiers CSV en HTML
for csv_file in *.csv; do
    html_file="${csv_file%.csv}.html"
    
    # Générer le tableau HTML
    awk -F',' -v map="$country_iso_map_string" '
        BEGIN {
            split(map, arr, " ")
            for (i in arr) {
                split(arr[i], kv, "=")
                country_iso_map[kv[1]] = kv[2]
            }

            print "<!DOCTYPE html>"
            print "<html>"
            print "<head>"
            print "<meta charset=\"utf-8\">"
            print "</head>"
            print "<body>"
            print "<h2>Tableau des médailles</h2>"
            print "<img href=\"./logo.png\" width=\"100\" heigh=\"120\" alt=\"logo des JO de Paris 2024\">"
            print "<table border=\"1\">"
            print "<style>table {font-size:0.3em;}</style>"
        }
        {
            print "<tr>"
            for(i=1; i<=NF; i++) {
                print "<td>" $i "</td>"
            }
            print "</tr>"
        }
        END {print "</table></body></html>"}' "$csv_file" > "$html_file"
    
    # Ajouter les images après avoir créé le tableau
    awk -F',' -v map="$country_iso_map_string" '
        BEGIN {
            split(map, arr, " ")
            for (i in arr) {
                split(arr[i], kv, "=")
                country_iso_map[kv[1]] = kv[2]
            }
        }
        {
            print "<tr>"
            for(i=1; i<=NF; i++) {
                if (country_iso_map[$i] != "") {
                    img_path = "./flags/small/" country_iso_map[$i] ".png"
                    print "<td><img src=\"" img_path "\" alt=\"" $i "\" width=\"30\" height=\"30\"></td>"
                } else {
                    print "<td></td>"
                }
            }
            print "</tr>"
        }' "$csv_file" >> "$html_file"
done
