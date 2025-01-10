#!/bin/bash

# Script principal pour automatiser les appels d'autres scripts

# Appel du premier script
./flags.bash

# Vérification du succès du premier script
if [ $? -ne 0 ]; then
    echo "Le flags.bash a échoué"
    exit 1
fi

# Appel du deuxième script
./medaille.bash

# Vérification du succès du deuxième script
if [ $? -ne 0 ]; then
    echo "Le medaille.bash a échoué"
    exit 1
fi

# Appel du troisième script
./xlsx_2_csv_2_html.bash

# Vérification du succès du troisième script
if [ $? -ne 0 ]; then
    echo "Le xlsx_2_csv_2_html.bash a échoué"
    exit 1
fi



echo "Tous les scripts ont été exécutés avec succès"