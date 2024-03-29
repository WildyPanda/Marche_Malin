import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/ui/login.dart';
import 'package:marche_malin/ui/test.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const TestPage())
            );
          },
          child: const Text("Test page"),
        ),
      ),
    );
  }
}
