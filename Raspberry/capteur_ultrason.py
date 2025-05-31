import smbus
import time

SRF08_ADDR = 0x70
bus = smbus.SMBus(1)
print("Interface I2C initialisée avec succès.")

while True:
    try:
        # Réinitialisation et réglage de la portée
        bus.write_byte_data(SRF08_ADDR, 0, 0x00)  # Réinitialisation
        time.sleep(0.1)
        bus.write_byte_data(SRF08_ADDR, 1, 24)    # Portée max ~1 m
        time.sleep(0.1)

        # Déclencher une mesure
        bus.write_byte_data(SRF08_ADDR, 0, 0x81)
        time.sleep(0.1)

        # Lire les registres
        high = bus.read_byte_data(SRF08_ADDR, 2)
        low = bus.read_byte_data(SRF08_ADDR, 3)
        print(f"Valeur brute - High: {hex(high)}, Low: {hex(low)}")

        # Calculer la distance
        distance = (high << 8) + low
        print(f"Distance mesurée : {distance} cm")

    except Exception as e:
        print(f"Erreur I2C : {e}")
        time.sleep(1)

