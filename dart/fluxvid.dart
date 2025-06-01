import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'socket.dart';

class FluxVideo extends StatefulWidget {
  const FluxVideo({super.key});

  @override
  State<FluxVideo> createState() => _FluxVideoState();
}

class _FluxVideoState extends State<FluxVideo> {
  Uint8List? _latestImage;

  @override
  void initState() {
    super.initState();

    SocketService().onMessageReceived = (String message) {
      print(" Message reçu : $message");

      // On ne traite que les messages JSON (commençant par {)
      if (!message.trim().startsWith('{')) {
        print(" Ignoré : message non-JSON");
        return;
      }

      try {
        final json = jsonDecode(message);
        if (json is Map && json.containsKey('video')) {
          final base64Image = json["video"];
          final imageBytes = base64Decode(base64Image);
          setState(() {
            _latestImage = imageBytes;
          });
        } else {
          print(" JSON valide mais sans image : $json");
        }
      } catch (e) {
        print(" Erreur de décodage JSON/image : $e");
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: _latestImage != null
          ? Image.memory(_latestImage!, fit: BoxFit.contain)
          : const Center(
        child: Text(
          "Aucune image reçue",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}