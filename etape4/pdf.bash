#!/usr/bin/bash

# Exécute un conteneur Docker en arrière-plan avec le conteneur sae103-html2pdf
container_id=$(docker run --rm -dti sae103-html2pdf)

# Activer la gestion des glob patterns pour ignorer les fichiers sans correspondance
shopt -s nullglob

# Conversion des fichiers HTML en PDF
for file in *.html; do
    # Copier le fichier HTML dans le conteneur Docker
    docker cp "$file" "${container_id}:/tmp/${file}"
    
    # Utiliser wkhtmltopdf pour convertir le fichier HTML en PDF
    docker exec "${container_id}" weasyprint "/tmp/${file}" "/tmp/${file%.html}.pdf"
    
    # Copier le fichier PDF généré de Docker vers l'hôte
    docker cp "${container_id}:/tmp/${file%.html}.pdf" "${file%.html}.pdf"
done

# Arrêter le conteneur Docker après traitement
docker stop "${container_id}"

