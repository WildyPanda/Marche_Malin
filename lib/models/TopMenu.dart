

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/services/service.dart';
import 'package:marche_malin/ui/login.dart';
import 'package:marche_malin/ui/profile.dart';
import '../globals.dart' as globals;

class TopMenu extends StatefulWidget {
  bool logged = false;

  TopMenu({super.key});

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  @override
  Widget build(BuildContext context) {
    // listen for when the user change and if the mail has changed update it.
    FirebaseAuth.instance.userChanges()
        .listen((User? user) {
      if(user != null){
        if(globals.email != user.email){
          globals.email = user.email!;
          print(user.email);
          SaveEmail(user.email);
        }
      }
    });

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      // called when the listener is registered, when the user log in and when he log out
      if (user == null) {
        setState(() {
          widget.logged = false;
        });
      } else {
        setState(() {
          widget.logged = true;
        });
      }
    });
    return Row(
      children: [
        const Text("Menu"),
        const Expanded(child:
        Center(
          child: Text("Marche Malin"),
        ),
        ),
        Visibility(
          visible: !widget.logged,
          replacement: ElevatedButton(
              onPressed: () async {
                /*await FirebaseAuth.instance.signOut();*/
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfilePage())
                );
              },
              child: const Text("Profile")
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Login())
              );
            },
            child: const Text("Login"),
          ),
        ),

      ],
    );
  }

}
