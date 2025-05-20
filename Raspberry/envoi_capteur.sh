#!/bin/bash

# Définir les fichiers de demande et de sortie
REQUEST_FILE="/home/btscie12/requete.txt"
OUTPUT_FILE="/home/btscie12/capteur_donnee.txt"

# Créer les fichiers avec les bonnes permissions
touch "$REQUEST_FILE" 2>/dev/null || { echo "Erreur: Impossible de créer $REQUEST_FILE. Vérifiez les permissions avec sudo." >&2; exit 1; }
touch "$OUTPUT_FILE" 2>/dev/null || { echo "Erreur: Impossible de créer $OUTPUT_FILE. Vérifiez les permissions avec sudo." >&2; exit 1; }
chown btscie12:btscie12 "$REQUEST_FILE" "$OUTPUT_FILE" 2>/dev/null || { echo "Erreur: Impossible de changer le propriétaire des fichiers." >&2; exit 1; }
chmod 666 "$REQUEST_FILE" "$OUTPUT_FILE" 2>/dev/null || { echo "Erreur: Impossible de définir les permissions des fichiers." >&2; exit 1; }

# Vider les fichiers au démarrage
echo "" > "$REQUEST_FILE" 2>/dev/null || { echo "Erreur: Impossible d'écrire dans $REQUEST_FILE." >&2; exit 1; }
echo "" > "$OUTPUT_FILE" 2>/dev/null || { echo "Erreur: Impossible d'écrire dans $OUTPUT_FILE." >&2; exit 1; }

# Vérifier si I2C est disponible
if ! i2cdetect -y 1 > /dev/null 2>&1; then
echo "Erreur: I2C non disponible. Vérifiez la configuration." >&2
exit 1
fi

# Fonction pour lire les capteurs
read_sensors() {
local DATA=""

# Vérifier la détection I2C pour TPA81 (0x68), PCF8591 (0x48) et SRF08 (0x70)
if i2cdetect -y 1 | grep -q "68"; then
TPA81_FOUND=true
else
TPA81_FOUND=false
fi
if i2cdetect -y 1 | grep -q "48"; then
ADC_FOUND=true
else
ADC_FOUND=false
fi
if i2cdetect -y 1 | grep -q "70"; then
SRF08_FOUND=true
else
SRF08_FOUND=false
fi

DATA="=== Données des capteurs ===\n"

# Lecture des températures (TPA81 à 0x68)
if [ "$TPA81_FOUND" = true ]; then
DATA+="Températures (TPA81):\n"
for i in {1..8}; do
temp=$(i2cget -y 1 0x68 $i 2>/dev/null || echo "Erreur")
if [ "$temp" = "Erreur" ] || [ "$temp" = "0x00" ]; then
DATA+="Capteur $i: Erreur ou température hors plage\n"
else
temp_decimal=$(printf "%d" "$temp")
DATA+="Capteur $i: $temp_decimal °C\n"
fi
done
else
DATA+="Températures (TPA81):\n"
DATA+="Erreur: TPA81 non détecté\n"
fi

# Lecture de l'ultrason (SRF08 à 0x70)
if [ "$SRF08_FOUND" = true ]; then
# Envoyer la commande pour mesurer la distance en cm (0x51)
i2cset -y 1 0x70 0x00 0x51 2>/dev/null
# Attendre que la mesure soit prête (environ 65ms selon la datasheet)
sleep 0.07
# Lire les deux octets (distance sur 16 bits)
high_byte=$(i2cget -y 1 0x70 0x02 2>/dev/null || echo "Erreur")
low_byte=$(i2cget -y 1 0x70 0x03 2>/dev/null || echo "Erreur")
if [ "$high_byte" != "Erreur" ] && [ "$low_byte" != "Erreur" ]; then
# Combiner les octets pour obtenir la distance
high_decimal=$(printf "%d" "$high_byte")
low_decimal=$(printf "%d" "$low_byte")
distance=$(( (high_decimal << 8) + low_decimal ))
DATA+="Ultrason (SRF08):\n"
DATA+="Distance: $distance cm\n"
else
DATA+="Ultrason (SRF08):\n"
DATA+="Distance: Erreur de lecture ou non connecté\n"
fi
else
DATA+="Ultrason (SRF08):\n"
DATA+="Distance: SRF08 non détecté\n"
fi

# Lecture des gaz (MQ-2 à 0x48)
if [ "$ADC_FOUND" = true ]; then
gas=$(i2cget -y 1 0x48 0 2>/dev/null || echo "Erreur") # A0 pour MQ-2
gas2=$(i2cget -y 1 0x48 1 2>/dev/null || echo "Erreur") # A1 pour MQ-135
if [ "$gas" != "Erreur" ]; then
gas_decimal=$(printf "%d" "$gas")
DATA+="Gaz (MQ-2):\n"
DATA+="Gaz: $gas_decimal\n"
else
DATA+="Gaz (MQ-2):\n"
DATA+="Gaz: Non connecté ou erreur\n"
fi
if [ "$gas2" != "Erreur" ]; then
gas2_decimal=$(printf "%d" "$gas2")
DATA+="Gaz (MQ-135):\n"
DATA+="Gaz: $gas2_decimal\n"
else
DATA+="Gaz (MQ-135):\n"
DATA+="Gaz: Non connecté ou erreur\n"
fi
else
DATA+="Gaz (MQ-2/MQ-135):\n"
DATA+="Gaz: ADC (PCF8591) non détecté\n"
fi

DATA+="------------------------\n"
echo -e "$DATA" > "$OUTPUT_FILE" 2>/dev/null || { echo "Erreur: Impossible d'écrire dans $OUTPUT_FILE" >&2; exit 1; }
}

# Boucle principale pour surveiller les demandes
while true; do
if [ -s "$REQUEST_FILE" ]; then
read_sensors
echo "" > "$REQUEST_FILE" 2>/dev/null || { echo "Erreur: Impossible de réinitialiser $REQUEST_FILE" >&2; exit 1; }
fi
sleep 0.5
done
