import RPi.GPIO as GPIO
import time
import bluetooth

# Configuration des broches
GPIO.setmode(GPIO.BCM) # Utilise le mode BCM pour numéroter les GPIO
GPIO.setup(18, GPIO.OUT) # Configure GPIO 18 comme sortie (signal PWM)
pwm = GPIO.PWM(18, 50) # Crée un signal PWM sur GPIO 18 avec une fréquence de 50 Hz (période de 20 ms)

# Démarre le PWM
pwm.start(0) # Démarre le PWM avec un rapport cyclique de 0 (aucun mouvement initial)

def set_angle(angle):
"""
Fonction pour définir l'angle du servomoteur.
L'angle (0-180) est converti en rapport cyclique (2.5-12.5%).
"""
duty = 2.5 + (angle / 18.0) # Calcule le rapport cyclique (0° -> 2.5%, 180° -> 12.5%)
pwm.ChangeDutyCycle(duty) # Applique le rapport cyclique
time.sleep(0.5) # Attend que le servomoteur atteigne la position
pwm.ChangeDutyCycle(0) # Désactive le signal pour économiser de l'énergie

# Configuration Bluetooth
server_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
server_sock.bind(("", bluetooth.PORT_ANY))
server_sock.listen(1)

print("En attente de connexion Bluetooth sur RFCOMM canal", server_sock.getsockname()[1])

client_sock, client_info = server_sock.accept()
print("Connexion acceptée depuis", client_info)

try:
while True:
data = client_sock.recv(1024).decode()
if not data:
break
print("Commande reçue:", data)
try:
angle = int(data)
if 0 <= angle <= 180:
set_angle(angle)
client_sock.send(f"Position ajustée à {angle}°\n".encode())
else:
client_sock.send("Angle hors limites (0-180)\n".encode())
except ValueError:
client_sock.send("Commande invalide, envoyez un angle (0-180)\n".encode())

except KeyboardInterrupt:
# Si tu appuies sur Ctrl+C, le programme s'arrête proprement
print("Arrêt du programme")
client_sock.close()
server_sock.close()
pwm.stop()
GPIO.cleanup()
