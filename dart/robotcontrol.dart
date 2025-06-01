import 'package:flutter/material.dart';
import 'orientation_helper.dart'; // Gère le basculement d'orientation écran
import 'socket.dart';             // Service de communication socket
import 'fluxvid.dart';            // Widget pour afficher le flux vidéo du robot

// Déclaration de la page principale de contrôle du robot
class RobotControlPage extends StatefulWidget {
  const RobotControlPage({super.key});

  @override
  _RobotControlPageState createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  // État de la connexion au robot (affiché à l'écran)
  String _status = "Déconnecté";

  // Action en cours affichée à l'écran
  String _currentActionS = "";

  /// Connexion au robot via Socket
  void _connectRobot() async {
    await SocketService().connect(host: '192.168.0.19', port: 12345);
    setState(() {
      _status = "Connecté";
    });
    _sendRequest('connect', 'Connexion'); // Notifie le robot et l'utilisateur
  }

  /// Déconnexion du robot
  void _disconnectRobot() {
    SocketService().disconnect();
    setState(() {
      _status = "Déconnecté";
    });
    _sendRequest('disconnect', 'Déconnexion'); // Envoie l'action de déconnexion
  }

  /// Arrêt immédiat du robot
  void _stop() {
    setState(() {
      _status = "S'arrête";
    });
    _sendRequest('stop', 'Stop'); // Notifie le robot d’un arrêt d’urgence
  }

  /// Envoie d'une commande au robot via socket
  /// [action] : commande à envoyer (ex : move_forward)
  /// [displayText] : texte à afficher temporairement à l’écran
  void _sendRequest(String action, [String? displayText]) {
    if (displayText != null) {
      setState(() {
        _currentActionS = displayText;
      });

      // Efface l'action affichée après 1 seconde
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _currentActionS = "";
          });
        }
      });
    }

    // Envoi de la commande via le service socket
    try {
      SocketService().send(action);
      print('Message envoyé : $action');
    } catch (e) {
      print('Erreur d\'envoi via socket : $e');
    }
  }

  /// Construit un bouton directionnel avec icône et action associée
  Widget _buildDirectionButton(
      String label, IconData icon, String action, String displayText) {
    return ElevatedButton(
      onPressed: () => _sendRequest(action, displayText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: const CircleBorder(), // Forme ronde
      ),
      child: Icon(icon, size: 30),
    );
  }

  /// Interface utilisateur principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contrôle du Robot'),
        backgroundColor: Colors.red,
        actions: [
          // Bouton pour basculer entre portrait/paysage
          IconButton(
            icon: const Icon(Icons.screen_rotation),
            onPressed: () {
              setState(() {
                OrientationHelper.toggleOrientation();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FluxVideo(), // Affichage du flux vidéo du robot
            const SizedBox(height: 20),

            // Affiche l'état de connexion du robot
            Text(
              'Robot : $_status',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Affiche temporairement l'action en cours (ex : "Avancer")
            if (_currentActionS.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Action : $_currentActionS',
                style: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ],
            const SizedBox(height: 30),

            // Boutons de base : Stop, Connexion, Déconnexion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _stop, child: const Text('Stop')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _connectRobot, child: const Text('Connexion')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _disconnectRobot, child: const Text('Déconnexion')),
              ],
            ),
            const SizedBox(height: 40),

            // Zone des contrôles directionnels du robot
            Column(
              children: [
                // Ligne : Haut
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 70),
                    _buildDirectionButton("Haut", Icons.arrow_upward, "move_forward", "Avancer"),
                    const SizedBox(width: 70),
                  ],
                ),

                // Ligne : Gauche - Rotation - Droite
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDirectionButton("Gauche", Icons.arrow_back, "move_forward_left", "Gauche"),
                    _buildDirectionButton("Rotation", Icons.sync, "rotation", "Rotation"),
                    _buildDirectionButton("Droite", Icons.arrow_forward, "move_forward_right", "Droite"),
                  ],
                ),

                // Ligne : BasGauche - Bas - BasDroite
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDirectionButton("BasGauche", Icons.turn_left, "move_backward_left", "Reculer à gauche"),
                    _buildDirectionButton("Bas", Icons.arrow_downward, "move_backward", "Reculer"),
                    _buildDirectionButton("BasDroite", Icons.turn_right, "move_backward_right", "Reculer à droite"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
