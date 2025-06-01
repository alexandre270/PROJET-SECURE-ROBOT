import 'package:flutter/material.dart';
import 'orientation_helper.dart'; // Importation de la bibliothèque pour la gestion de l'orientation

// Page affichant les données télémétriques
class TelemetryPage extends StatefulWidget {
  const TelemetryPage({super.key});

  @override
  _TelemetryPageState createState() => _TelemetryPageState();
}

class _TelemetryPageState extends State<TelemetryPage> {
  // Déclaration des variables pour stocker les données de télémétrie
  double temperature = 46.5; // Température en degrés Celsius
  double inclination = 5.0; // Inclinaison en degrés
  double distance = 1.5; // Distance en mètres

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application avec un titre et un bouton pour changer l'orientation
      appBar: AppBar(
        title: const Text('Télémétrie'),
        backgroundColor: Colors.blue,
        actions: [
          // Bouton pour alterner l'orientation de l'écran (portrait / paysage)
          IconButton(
            icon: const Icon(Icons.screen_rotation),
            onPressed: () {
              // Appel de la fonction pour changer l'orientation de l'écran
              OrientationHelper.toggleOrientation();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espacement autour du contenu principal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer les éléments verticalement
          children: [
            // Affichage des données sous forme de cartes avec des icônes et des valeurs
            _buildTelemetryCard('Température', temperature, '°C', Icons.thermostat),
            const SizedBox(height: 20),
            _buildTelemetryCard('Inclinaison du sol', inclination, '°', Icons.landscape),
            const SizedBox(height: 20),
            _buildTelemetryCard('Distance du robot', distance, 'm', Icons.straighten),
          ],
        ),
      ),
    );
  }

  // Widget qui crée une carte pour afficher chaque donnée de télémétrie
  Widget _buildTelemetryCard(String title, double value, String unit, IconData icon) {
    return Card(
      elevation: 5, // Ombre portée de la carte
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Coins arrondis de la carte
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Espacement interne de la carte
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement entre l'icône et le texte
          children: [
            // Icône représentant chaque donnée
            Icon(icon, size: 40, color: Colors.blue),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche pour les textes
              children: [
                // Titre de la donnée
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Valeur de la donnée avec son unité
                Text('$value $unit', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
