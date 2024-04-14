import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/UserDTOs.dart';
import 'package:marche_malin/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:marche_malin/services/service.dart';
import '../globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController usernameTextController = TextEditingController();
  bool modifyingUsername = false;
  bool modifyingEmail = false;
  bool modifyingPhone = false;
  Future<AppUser> user = getUser();
  String res = "";

  Future<void> savePhone() async {
    var header = globals.getHeaderContentType();
    SavePhoneDTO body = SavePhoneDTO(phoneTextController.text);
    http.post(globals.getUrl("user/UpdatePhoneNb"), headers: header, body: json.encode(body.toJson()));
  }

  Future<void> saveUsername() async {
    var header = globals.getHeaderContentType();
    SaveUsernameDTO body = SaveUsernameDTO(usernameTextController.text);
    http.post(globals.getUrl("user/UpdateUsername"), headers: header, body: json.encode(body.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    passwordTextController.text = "";
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AppUser? data = snapshot.data;
            return Builder(
              builder: (context) {
                if (modifyingEmail) {
                  emailTextController.text = data!.email;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Nouvelle adresse email"),
                          Visibility(
                            visible: res != "",
                            child: Text(res),
                          ),
                          TextFormField(
                            controller: emailTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nouvelle adresse email",
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (input) => EmailValidator.validate(input!) ? null : "Incorrect mail",
                          ),
                          TextFormField(
                            controller: passwordTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Mot de passe actuel",
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var fbFutureUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: data.email,
                                password: passwordTextController.text,
                              );
                              var fbUser = fbFutureUser.user;
                              if (fbUser != null) {
                                fbUser.verifyBeforeUpdateEmail(emailTextController.text);
                                setState(() {
                                  res = "Email de vérification envoyé";
                                  modifyingEmail = false;
                                });
                              } else {
                                setState(() {
                                  res = "Mot de passe incorrect";
                                });
                              }
                            },
                            child: const Text("Sauvegarder"),
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
                  );
                } else if (modifyingPhone) {
                  phoneTextController.text = data!.phone;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Nouveau numéro de téléphone"),
                          Visibility(
                            visible: res != "",
                            child: Text(res),
                          ),
                          TextFormField(
                            controller: phoneTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nouveau numéro de téléphone",
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await savePhone();
                              setState(() {
                                modifyingPhone = false;
                                user = getUser();
                              });
                            },
                            child: const Text("Sauvegarder"),
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
                  );
                } else if (modifyingUsername) {
                  usernameTextController.text = data!.username;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Nouveau nom d'utilisateur"),
                          Visibility(
                            visible: res != "",
                            child: Text(res),
                          ),
                          TextFormField(
                            controller: usernameTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nouveau nom d'utilisateur",
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await saveUsername();
                              setState(() {
                                modifyingUsername = false;
                                user = getUser();
                              });
                            },

                            child:
                            const Text("Sauvegarder"),
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
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: res != "",
                            child: Text(res),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Nom d'utilisateur : ${data?.username}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    modifyingUsername = true;
                                  });
                                },
                                child: const Text("Modifier le nom d'utilisateur"),
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
                          SizedBox(height: 20.0), // Espacement entre les sections
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Email : ${data?.email}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    modifyingEmail = true;
                                  });
                                },
                                child: const Text("Modifier l'adresse email"),
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
                          SizedBox(height: 20.0), // Espacement entre les sections
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Numéro de téléphone : ${data?.phone}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    modifyingPhone = true;
                                  });
                                },
                                child: const Text("Modifier le numéro de téléphone"),
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
                          SizedBox(height: 20.0), // Espacement avant le bouton de déconnexion
                          ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: const Text("Déconnexion"),
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
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text("Impossible de récupérer les données"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
