import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool logged = false;

  final emailTextController = TextEditingController();
  final password1TextController = TextEditingController();
  final password2TextController = TextEditingController();

  String signInResult = "";

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
            const Text("Creation d'un compte"),
            Visibility(
              visible: signInResult != "",
              child: Text(signInResult),
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
              controller: password1TextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            TextFormField(
              controller: password2TextController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) => password2TextController.text == password1TextController.text ? null : "Les mots de passe sont differends",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Repetez le mot de passe',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if(password2TextController.text == password1TextController.text){
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailTextController.text,
                      password: password1TextController.text,
                    );
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        this.signInResult = 'The password provided is too weak.';
                      });
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        this.signInResult = 'The account already exists for that email.';
                      });
                    }
                  } catch (e) {
                    setState(() {
                      this.signInResult = "Erreur inconnu";
                    });
                  }
                }
                else{
                  setState(() {
                    this.signInResult = "Les mots de passe sont differends";
                  });
                }
              },
              child: Text("S'inscrire")
            )
          ],
        ),
      ),
    );
  }
}
