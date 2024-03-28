
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Column(
        children: [
          const Text("Bonjour"),
          const Text("Connectez-vous pour decouvrir toutes nos fonctionnalités"),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'E-mail',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Mot de passe',
            ),
          ),
          ElevatedButton(
            onPressed: () {  },
            child: const Text("Mot de passe oublié"),
          ),
          ElevatedButton(
            onPressed: () {  },
            child: const Text("Se connecter"),
          ),
          ElevatedButton(
            onPressed: () {  },
            child: const Text("Créer un compte"),
          ),
        ],
      ),
    );
  }
}
