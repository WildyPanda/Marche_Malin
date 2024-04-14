library globals;

import 'package:firebase_auth/firebase_auth.dart';

String token = "";
String email = "";
bool logged = false;

init(){
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null){
      logged = false;
    } else {
      logged = true;
    }
  });
}

getHeader(){
  return {
    "authorization": 'Bearer $token'
  };
}

getHeaderContentType(){
  return {
    "authorization": 'Bearer $token',
    "content-type" : "application/json"
  };
}

getUrl(String url){
  return Uri.http("localhost:8083", url);
}