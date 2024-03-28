
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/ui/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool logged = false;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String loginResult = "";

  var listen;

  @override
  void dispose() {
    if(listen != null){
      listen.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listen = FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      // called when the lsitener is registered, when the user log in and when he log out
      if (user == null) {
        setState(() {
          logged = false;
        });
      } else {
        setState(() {
          logged = true;
        });
      }
    });
    return Scaffold(
      appBar: const TopMenuAppBar(),
      body: Visibility(
        visible: !logged,
        replacement: const Text("Vous etes deja connecté"),
        child: Column(
          children: [
            const Text("Bonjour"),
            const Text("Connectez-vous pour decouvrir toutes nos fonctionnalités"),
            Visibility(
              visible: loginResult != "",
              child: Text(loginResult),
            ),
            TextFormField(
              controller: emailTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E-mail',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) => EmailValidator.validate(input!) ? null : "Incorrect mail",
            ),
            TextFormField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mot de passe',
              ),
              obscureText: true,
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
                  Navigator.pop(context);
                }on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() {
                      loginResult = 'No user found for that email.';
                    });
                  } else if (e.code == 'wrong-password') {
                    setState(() {
                      loginResult = 'Wrong password provided for that user.';
                    });
                  }
                  setState(() {
                    loginResult = e.code;
                  });
                }
              },
              child: const Text("Se connecter"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register())
                );
              },
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
