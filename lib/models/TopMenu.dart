import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/services/service.dart';
import 'package:marche_malin/ui/login.dart';
import 'package:marche_malin/ui/profile.dart';
import '../globals.dart' as globals;

class TopMenu extends StatefulWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  bool logged = false;

  @override
  Widget build(BuildContext context) {
    // Listen for user changes and update email if necessary
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        if (globals.email != user.email) {
          setState(() {
            globals.email = user.email!;
            print(user.email);
            SaveEmail(user.email);
          });
        }
      }
    });

    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        logged = user != null;
      });
    });

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text("Marché Malin"),
            ),
          ),
          Visibility(
            visible: !logged,
            replacement: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700, // Texte noir
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3), // Border radius de 3px
                ),
              ),
              child: const Text("Profil"),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700, // Texte noir
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3), // Border radius de 3px
                ),
              ),
              child: const Text("Se connecter"),
            ),
          ),
        ],
      ),
    );
  }
}
