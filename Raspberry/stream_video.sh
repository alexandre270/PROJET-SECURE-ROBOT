#!/bin/bash

# Paramètres
DEVICE="/dev/video0"
DEST_IP="192.168.0.19"
PORT="1234"

# Vérification du périphérique
if [ ! -e "$DEVICE" ]; then
echo "Erreur : Le périphérique $DEVICE n'existe pas."
exit 1
fi

# Vérification réseau
echo "Vérification de la connexion réseau..."
for i in {1..5}; do
if ping -c 1 "$DEST_IP" >/dev/null 2>&1; then
echo "Connexion réussie."
break
fi
echo "Échec de la connexion, tentative $i/5..."
sleep 2
done

if ! ping -c 1 "$DEST_IP" >/dev/null 2>&1; then
echo "Erreur : Impossible de contacter $DEST_IP."
exit 1
fi

# Lancement du stream UDP
echo "Lancement du stream..."
/usr/bin/ffmpeg \
-re \
-f v4l2 \
-framerate 5 \
-i "$DEVICE" \
-vf "scale=160:120" \
-c:v libx264 \
-preset ultrafast \
-tune zerolatency \
-b:v 600k \
-bufsize 600k \
-g 5 \
-f mpegts "udp://$DEST_IP:$PORT?pkt_size=1316&buffer_size=65536" \
-loglevel debug 2>> /home/btscie12/ffmpeg.log &

echo "Streaming démarré."
	

