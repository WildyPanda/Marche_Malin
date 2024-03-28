import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
        // called when the lsitener is registered, when the user log in and when he log out
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
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
      appBar: AppBar(
        title: TopMenu(),
      ),
    );
  }
}
