import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/ui/register.dart';
import '../globals.dart' as globals;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
      appBar: const TopMenuAppBar(),
      body: Visibility(
        visible: !globals.logged,
        replacement: const Text("Vous êtes déjà connecté"),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Connectez-vous pour découvrir toutes nos fonctionnalités"),
              Visibility(
                visible: loginResult.isNotEmpty,
                child: Text(loginResult),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'E-mail',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) => EmailValidator.validate(input!) ? null : "Incorrect mail",
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: passwordTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mot de passe',
                  ),
                  obscureText: true,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Ajoutez ici le code pour gérer le clic sur "Mot de passe oublié"
                  // Par exemple, afficher une boîte de dialogue pour la récupération de mot de passe.
                  print("Mot de passe oublié cliqué");
                },
                child: Text(
                  "Mot de passe oublié",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailTextController.text,
                      password: passwordTextController.text,
                    );
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      if (e.code == 'user-not-found') {
                        loginResult = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        loginResult = 'Wrong password provided for that user.';
                      } else {
                        loginResult = e.code!;
                      }
                    });
                  }
                },
                child: const Text("Se connecter"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text("Créer un compte"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
