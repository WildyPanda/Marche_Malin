

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/ui/login.dart';

class TopMenu extends StatefulWidget {
  bool logged = false;

  TopMenu({super.key});

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      // called when the lsitener is registered, when the user log in and when he log out
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
                await FirebaseAuth.instance.signOut();
              },
              child: const Text("Log out")
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
