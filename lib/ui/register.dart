import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String signUpResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopMenuAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Création d'un compte"),
            Visibility(
              visible: signUpResult.isNotEmpty,
              child: Text(signUpResult),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'E-mail',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) => EmailValidator.validate(input!) ? null : "E-mail incorrect",
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Répétez le mot de passe',
                ),
                obscureText: true,
                validator: (input) {
                  if (input != passwordController.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (confirmPasswordController.text == passwordController.text) {
                  try {
                    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    Navigator.pop(context); // Navigate back to previous screen
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      if (e.code == 'weak-password') {
                        signUpResult = 'Le mot de passe est trop faible.';
                      } else if (e.code == 'email-already-in-use') {
                        signUpResult = 'Ce compte existe déjà pour cet e-mail.';
                      } else {
                        signUpResult = e.message ?? "Erreur inconnue";
                      }
                    });
                  }
                } else {
                  setState(() {
                    signUpResult = "Les mots de passe ne correspondent pas";
                  });
                }
              },
              child: const Text("S'inscrire"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.orange.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
