import 'package:flutter/material.dart';
import 'orientation_helper.dart'; // Gère le changement d’orientation écran

// Menu principal de l’application (Stateless = pas d’état modifiable)
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application en haut
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Menu Principal'), // Titre au centre
        centerTitle: true,
        actions: [
          // Bouton pour changer l’orientation de l’écran
          IconButton(
            icon: const Icon(Icons.screen_rotation),
            onPressed: () {
              OrientationHelper.toggleOrientation(); // Appel à l’utilitaire
            },
          ),
        ],
      ),

      // Corps de la page
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Marge autour du contenu
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
          children: [
            // Message de bienvenue
            const Text(
              'Bienvenue sur SecuRobot!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20), // Espacement vertical

            // Affiche les boutons dans une grille (2 colonnes)
            GridView.count(
              shrinkWrap: true, // Adapte la taille à son contenu
              crossAxisCount: 2, // 2 boutons par ligne
              mainAxisSpacing: 10, // Espace vertical entre les boutons
              crossAxisSpacing: 10, // Espace horizontal entre les boutons
              children: [
                // Bouton pour accéder à la page de contrôle du robot
                _buildMenuButton(context, 'Contrôle Robot', Icons.touch_app, '/robot'),

                // Bouton pour accéder à la page de télémétrie
                _buildMenuButton(context, 'Télémétrie', Icons.dashboard, '/telemetry'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Fonction utilitaire pour créer un bouton du menu
  /// [context] : contexte Flutter pour la navigation
  /// [title] : texte affiché sur le bouton
  /// [icon] : icône affichée
  /// [route] : route nommée vers laquelle naviguer
  Widget _buildMenuButton(BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Coins arrondis
      ),
      onPressed: () {
        Navigator.pushNamed(context, route); // Navigation vers une autre page
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adapte la taille verticale au contenu
        children: [
          Icon(icon, size: 40),          // Icône du bouton
          const SizedBox(height: 8),     // Petit espace
          Text(title, textAlign: TextAlign.center), // Texte sous l’icône
        ],
      ),
    );
  }
}
