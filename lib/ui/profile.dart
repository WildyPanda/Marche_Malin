import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/UserDTOs.dart';
import 'package:marche_malin/models/user.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final EmailTextController = TextEditingController();
  final PasswordTextController = TextEditingController();
  bool ModifyingUsername = false;
  bool ModifyingEmail = false;
  bool ModifyingPhone = false;
  Future<AppUser> user = getUser();
  String res = "";
  var listen;

  static Future<AppUser> getUser() async {
    var header = globals.getHeader();
    var resp = await http.get(globals.getUrl("user/get"), headers: header);
    var json = jsonDecode(utf8.decode(resp.bodyBytes));
    return AppUser.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    PasswordTextController.text = "";
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot){
          if(snapshot.hasData){
            AppUser? data = snapshot.data;
            return Builder(
              builder: (context) {
                if(ModifyingEmail){
                  EmailTextController.text = data!.email;
                  return Column(
                    children: [
                      Text("Nouvelle adresse email"),
                      Visibility(
                        visible: res != "",
                        child: Text(res),
                      ),
                      TextFormField(
                        controller: EmailTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nouvelle adresse email",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) => EmailValidator.validate(input!) ? null : "Incorrect mail",
                      ),
                      TextFormField(
                        controller: PasswordTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Current password",
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var fbFutureUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: data!.email,
                                password: PasswordTextController.text
                            );
                            var fbUser = fbFutureUser.user;
                            if(fbUser != null){
                              fbUser.verifyBeforeUpdateEmail(EmailTextController.text);
                              setState(() {
                                res = "Verification email sent";
                                ModifyingEmail = false;
                              });
                            }
                            else{
                              setState(() {
                                res = "Wrong password";
                              });
                            }
                          },
                          child: Text("Save email")
                      )
                    ],
                  );
                }
                else if(ModifyingPhone){
                  return Text("Phone");
                }
                else if(ModifyingUsername){
                  return Text("Username");
                }
                else{
                  return Column(
                    children: [
                      Visibility(
                        visible: res != "",
                        child: Text(res),
                      ),
                      Expanded(
                        child: Row(
                        children: [
                          Text("nom d'utilisateur : ${data?.username}"),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  ModifyingUsername = true;
                                });
                              },
                              child: const Text("Modifier le nom d'utilisateur")
                          ),
                        ],
                      ),
                      ),
                      Expanded(
                          child: Row(
                            children: [
                              Text("email : ${data?.email}"),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      ModifyingEmail = true;
                                    });
                                  },
                                  child: const Text("Modifier l'adresse email'")
                              ),
                            ],
                          ),
                      ),
                      Expanded(
                          child: Row(
                            children: [
                              Text("numero de telephone : ${data?.phone}"),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      ModifyingPhone = true;
                                    });
                                  },
                                  child: const Text("Modifier le numero de telephone")
                              ),
                            ],
                          ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: Text("Log out"),
                        ),
                      )
                    ],
                  );
                }
              },
            );
          }
          else if(snapshot.hasError){
            print(snapshot.error);
            return const Center(
              child: Text("Impossible de recuperrer les données"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
