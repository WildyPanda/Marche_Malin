
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String loginResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Column(
        children: [
          const Text("Bonjour"),
          const Text("Connectez-vous pour decouvrir toutes nos fonctionnalités"),
          Visibility(
            visible: loginResult != "",
            child: Text(loginResult),
          ),
          TextFormField(
            controller: emailTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'E-mail',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (input) => EmailValidator.validate(input!) ? null : "Incorrect mail",
          ),
          TextFormField(
            controller: passwordTextController,
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
            onPressed: () async {
              try{
                final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailTextController.text,
                    password: passwordTextController.text
                );
                setState(() {
                  this.loginResult = "Successfully logged in";
                });
              }on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  setState(() {
                    this.loginResult = 'No user found for that email.';
                  });
                } else if (e.code == 'wrong-password') {
                  setState(() {
                    this.loginResult = 'Wrong password provided for that user.';
                  });
                }
                setState(() {
                  this.loginResult = e.code;
                });
              }
            },
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
