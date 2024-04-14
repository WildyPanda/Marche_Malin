import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/UserDTOs.dart';
import 'package:marche_malin/ui/Search.dart';
import 'package:marche_malin/ui/create_post.dart';
import 'package:marche_malin/ui/post.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  globals.init();
  FirebaseAuth.instance
      .idTokenChanges()
      .listen((User? user) async {
    if (user != null) {
      globals.token = (await user.getIdToken())!;
    }
    else{
      globals.token = "";
    }
  });
  runApp(const MarcheMalin());
}

class MarcheMalin extends StatelessWidget {
  const MarcheMalin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marche Malin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(title: 'Marche Malin'),
    );
  }
}

class HomePage extends StatelessWidget {
  String title;

  HomePage({required this.title,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopMenuAppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
          child:
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostPage(postIndex: 1)),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700, // Texte noir
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Border radius de 10px
              ),
              padding: EdgeInsets.symmetric(vertical: 20), // Padding vertical
            ),
            child: const SizedBox(
              width: 250, // Largeur du bouton pour remplir la largeur disponible
              height: 50, // Hauteur fixe du bouton (60 pixels)
              child: Center(
                child: Text(
                  "Mes annonces",
                  style: TextStyle(fontSize: 18), // Taille de texte plus grande
                ),
              ),
            ),
          ),
          ),
          const SizedBox(height: 16),
          Center(
            child:
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePost()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700, // Texte noir
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Border radius de 10px
              ),
              padding: EdgeInsets.symmetric(vertical: 20), // Padding vertical
            ),
            child: const SizedBox(
              width: 250, // Largeur du bouton pour remplir la largeur disponible
              height: 50, // Hauteur fixe du bouton (60 pixels)
              child: Center(
                child: Text(
                  "Créer une annonce",
                  style: TextStyle(fontSize: 18), // Taille de texte plus grande
                ),
              ),
            ),
          ),
          ),
          const SizedBox(height: 16),
          Center(
          child:
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => SearchPage())
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700, // Texte noir
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Border radius de 10px
              ),
              padding: EdgeInsets.symmetric(vertical: 20), // Padding vertical
            ),
            child: const SizedBox(
              width: 250, // Largeur du bouton pour remplir la largeur disponible
              height: 50, // Hauteur fixe du bouton (60 pixels)
              child: Center(
                child: Text(
                  "Rechercher une annonce",
                  style: TextStyle(fontSize: 18), // Taille de texte plus grande
                ),
              ),
            ),
          ),
          )
        ]
      ),
    );
  }
}
