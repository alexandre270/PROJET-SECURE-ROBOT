// Permet de manipuler les préférences système, comme l'orientation de l'écran
import 'package:flutter/services.dart';

// Classe utilitaire pour gérer l'orientation de l'appareil
class OrientationHelper {
  // Attribut statique qui mémorise si l’orientation actuelle est en portrait
  static bool isPortrait = true;

  /// Méthode statique qui bascule entre mode portrait et paysage
  static void toggleOrientation() {
    if (isPortrait) {
      // Si l'app est en mode portrait, on force le passage en mode paysage
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,   // Mode paysage (gauche)
        DeviceOrientation.landscapeRight,  // Mode paysage (droite)
      ]);
    } else {
      // Sinon, on revient en mode portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,      // Portrait (haut classique)
        DeviceOrientation.portraitDown,    // Portrait inversé (peu utilisé)
      ]);
    }

    // Inverse l’état de l’indicateur
    isPortrait = !isPortrait;
  }
}
