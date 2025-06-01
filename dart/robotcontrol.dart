import 'package:flutter/material.dart';
import 'orientation_helper.dart';
import 'socket.dart';
import 'fluxvid.dart';

class RobotControlPage extends StatefulWidget {
  const RobotControlPage({super.key});

  @override
  _RobotControlPageState createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  String _status = "Déconnecté";
  String _currentActionS = "";

  void _connectRobot() async {
    await SocketService().connect(host: '192.168.0.19', port: 12346);
    setState(() {
      _status = "Connecté";
    });
    _sendRequest('connect', 'Connexion');
  }

  void _disconnectRobot() {
    SocketService().disconnect();
    setState(() {
      _status = "Déconnecté";
    });
    _sendRequest('disconnect', 'Déconnexion');
  }

  void _stop() {
    setState(() {
      _status = "S'arrête";
    });
    _sendRequest('stop', 'Stop');
  }

  void _sendRequest(String action, [String? displayText]) {
    if (displayText != null) {
      setState(() {
        _currentActionS = displayText;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _currentActionS = "";
          });
        }
      });
    }

    try {
      SocketService().send(action);
      print('Message envoyé : $action');
    } catch (e) {
      print('Erreur d\'envoi via socket : $e');
    }
  }

  Widget _buildDirectionButton(
      String label, IconData icon, String action, String displayText) {
    return ElevatedButton(
      onPressed: () => _sendRequest(action, displayText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: const CircleBorder(),
      ),
      child: Icon(icon, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contrôle du Robot'),
        backgroundColor: Colors.red,
        actions: [
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
            const FluxVideo(),
            const SizedBox(height: 20),
            Text(
              'Robot : $_status',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (_currentActionS.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Action : $_currentActionS',
                style: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ],
            const SizedBox(height: 30),
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 70),
                    _buildDirectionButton("Haut", Icons.arrow_upward, "move_forward", "Avancer"),
                    const SizedBox(width: 70),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDirectionButton("Gauche", Icons.arrow_back, "move_forward_left", "Gauche"),
                    _buildDirectionButton("Rotation", Icons.sync, "rotation", "Rotation"),
                    _buildDirectionButton("Droite", Icons.arrow_forward, "move_forward_right", "Droite"),
                  ],
                ),
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