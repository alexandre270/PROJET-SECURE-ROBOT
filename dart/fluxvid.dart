// Importation des bibliothèques nécessaires
import 'dart:convert';             // Pour décoder les messages JSON et les images en base64
import 'dart:typed_data';          // Pour manipuler les données binaires (Uint8List)
import 'package:flutter/material.dart'; // Widgets Flutter
import 'socket.dart';              // Service de socket personnalisé pour recevoir les messages

// Widget principal pour afficher le flux vidéo du robot
class FluxVideo extends StatefulWidget {
  const FluxVideo({super.key});

  @override
  State<FluxVideo> createState() => _FluxVideoState();
}

// État du widget FluxVideo
class _FluxVideoState extends State<FluxVideo> {
  // Contient la dernière image reçue sous forme binaire
  Uint8List? _latestImage;

  @override
  void initState() {
    super.initState();

    // Callback exécuté quand un message est reçu via socket
    SocketService().onMessageReceived = (String message) {
      print(" Message reçu : $message");

      // On ignore les messages qui ne sont pas des JSON (par exemple des réponses simples)
      if (!message.trim().startsWith('{')) {
        print(" Ignoré : message non-JSON");
        return;
      }

      try {
        // Décodage du message JSON
        final json = jsonDecode(message);

        // Vérifie que c'est bien un objet JSON contenant une clé "video"
        if (json is Map && json.containsKey('video')) {
          final base64Image = json["video"];           // Récupère la chaîne encodée en base64
          final imageBytes = base64Decode(base64Image); // Décode en bytes (Uint8List)

          // Mise à jour de l'interface avec la nouvelle image
          setState(() {
            _latestImage = imageBytes;
          });
        } else {
          print(" JSON valide mais sans image : $json"); // Cas où la clé 'video' n'est pas présente
        }
      } catch (e) {
        // Erreur lors du décodage JSON ou de l'image
        print(" Erreur de décodage JSON/image : $e");
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity, // Occupe toute la largeur disponible
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Bordure noire autour de l'image
      ),

      // Affiche l’image si elle a été reçue, sinon affiche un texte par défaut
      child: _latestImage != null
          ? Image.memory(_latestImage!, fit: BoxFit.contain) // Affiche l’image décodée
          : const Center(
              child: Text(
                "Aucune image reçue", // Message d’attente
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }
}
