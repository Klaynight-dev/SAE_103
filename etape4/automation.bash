#!/bin/bash

# Script permettant de lancer la chaine d'automatisation

# Télécharge les drapeaux dans un répertoire
./flag.bash

# Converti les fichiers TXT en HTML
./txt2html.bash

# Classe les pays avec le tableau des médailles
./medaille.bash

# Converti les fichiers XLSX en CSV puis en HTML
./xlsx_2_csv_2_html.bash

# Converti les fichiers HTML en PDF
#./pdf.bash

echo "Tous les scripts ont été exécutés avec succès"
