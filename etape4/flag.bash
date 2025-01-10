#!/bin/bash

#Liste complète des codes ISO Alpha-2 des pays
countries=(
  za al dz de ar am au at az bh be bw br bg ca cv cl cn cy co kp kr ci hr cu dk dm eg ec roa es us et fj fr ge gb gr gd gt hk hu in id ir ie il it jm jp jo kz ke kg xk lt my ma mx md mn no nz ug uz pk pa nl pe ph pl pr pt qa do cz ro lc rs sg sk si se ch tj tw th tn tr ua zm
)

#Répertoires de sortie
OUTPUT_DIR="flags"
SMALL_DIR="$OUTPUT_DIR/small"
FLOATING_DIR="$OUTPUT_DIR/floating"

mkdir -p "$SMALL_DIR" "$FLOATING_DIR"

#Téléchargement des drapeaux en 20 pixels de largeur
for CODE in "${countries[@]}"; do
  echo "Téléchargement du drapeau (20px) pour le pays : $CODE"
  wget -q -O "$SMALL_DIR/$CODE.png" "https://flagcdn.com/w20/$CODE.png"
done

#Téléchargement des drapeaux en 80x60 pixels
for CODE in "${countries[@]}"; do
  echo "Téléchargement du drapeau (80x60) pour le pays : $CODE"
  wget -q -O "$FLOATING_DIR/$CODE.png" "https://flagcdn.com/80x60/$CODE.png"
done

#Vérification des téléchargements
echo "Téléchargement terminé. Les drapeaux sont disponibles dans le répertoire $OUTPUT_DIR."