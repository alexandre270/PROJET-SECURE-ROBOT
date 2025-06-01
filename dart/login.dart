import 'package:flutter/material.dart';
import 'socket.dart'; 

// Widget d’authentification principal
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// État associé au widget LoginPage
class _LoginPageState extends State<LoginPage> {
  // Code principal saisi par l'utilisateur
  String _firstCode = '';

  // Code secondaire saisi par l'utilisateur
  String _secondCode = '';

  // Booléen pour savoir si on est à l'étape 2
  bool _stepTwo = false;

  /// Vérifie le premier code (étape 1)
  void _validateFirstCode() {
    if (_firstCode == "1234") {
      // Si correct, passe à l’étape 2
      setState(() {
        _stepTwo = true;
      });
    } else {
      // Sinon, affiche une erreur
      _showError("Code principal incorrect");
    }
  }

  /// Vérifie le second code (étape 2)
  void _validateSecondCode() {
    if (_secondCode == "5678") {
      // Si correct, navigue vers la page de menu (remplace la page actuelle)
      Navigator.pushReplacementNamed(context, '/menu');
    } else {
      // Sinon, affiche une erreur
      _showError("Code secondaire incorrect");
    }
  }

  /// Affiche un message d’erreur dans un SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Construction de l’interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentification')),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Marge intérieure
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
            // Affiche soit l’étape 1, soit l’étape 2
            children: _stepTwo ? _buildSecondStep() : _buildFirstStep(),
          ),
        ),
      ),
    );
  }

  /// Étape 1 : saisie du code principal
  List<Widget> _buildFirstStep() {
    return [
      const Text(
        "Entrez le code principal",
        style: TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 10), // Espacement vertical
      TextField(
        obscureText: true, // Masque le texte (comme un mot de passe)
        keyboardType: TextInputType.number, // Clavier numérique
        decoration: const InputDecoration(labelText: 'Code'),
        onChanged: (value) => _firstCode = value, // Stocke la valeur
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _validateFirstCode,
        child: const Text('Suivant'),
      ),
    ];
  }

  /// Étape 2 : saisie du code secondaire
  List<Widget> _buildSecondStep() {
    return [
      const Text(
        "Entrez le code secondaire",
        style: TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 10),
      TextField(
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Code secondaire'),
        onChanged: (value) => _secondCode = value,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _validateSecondCode,
        child: const Text('Valider'),
      ),
    ];
  }
}
