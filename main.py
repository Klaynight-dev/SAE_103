import csv
import requests

def get_iso_codes_from_api(input_file, output_file):
    """
    Lit un fichier CSV contenant des noms de pays, obtient leurs codes ISO via une API et les écrit dans un nouveau fichier.
    
    :param input_file: Chemin du fichier CSV d'entrée contenant les noms des pays.
    :param output_file: Chemin du fichier CSV de sortie contenant les codes ISO.
    """
    base_url = "https://restcountries.com/v3.1/name/"
    
    try:
        with open(input_file, mode='r', encoding='utf-8') as infile:
            reader = csv.reader(infile)
            
            # Liste pour stocker les noms des pays et leurs codes ISO
            country_iso_mapping = []
            
            for row in reader:
                if row:  # Vérifie que la ligne n'est pas vide
                    country_name = row[0]  # Supposons que le nom du pays est dans la première colonne
                    try:
                        # Appeler l'API pour obtenir les informations sur le pays
                        response = requests.get(f"{base_url}{country_name}")
                        if response.status_code == 200:
                            country_data = response.json()
                            # Prendre le premier résultat (le plus probable)
                            iso_code = country_data[0]['cca2']  # ISO Alpha-2
                            country_iso_mapping.append([country_name, iso_code])
                        else:
                            country_iso_mapping.append([country_name, "ISO introuvable"])
                    except Exception as e:
                        country_iso_mapping.append([country_name, f"Erreur : {e}"])
        
        with open(output_file, mode='w', encoding='utf-8', newline='') as outfile:
            writer = csv.writer(outfile)
            
            # Écrire les noms des pays et leurs codes ISO
            writer.writerow(["Nom du pays", "Code ISO"])  # En-tête
            writer.writerows(country_iso_mapping)
        
        print(f"Traitement terminé ! Les résultats sont enregistrés dans '{output_file}'.")
    
    except FileNotFoundError:
        print(f"Erreur : Le fichier '{input_file}' est introuvable.")
    except Exception as e:
        print(f"Une erreur s'est produite : {e}")

# Exemple d'utilisation
input_csv = "Tableau des medailles v1.csv"  # Remplace par le chemin de ton fichier CSV d'entrée
output_csv = "fichier_sortie.csv"  # Remplace par le chemin de ton fichier CSV de sortie
get_iso_codes_from_api(input_csv, output_csv)
