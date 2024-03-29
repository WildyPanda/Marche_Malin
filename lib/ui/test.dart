import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marche_malin/models/TopMenuAppBar.dart';
import '../globals.dart' as globals;


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // "localhost:8081", "test" correspond to localhost:8081/test
  final url = Uri.http("localhost:8081", "test");
  String response = "";

  Future<void> testRequest() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();

    final header = { "authorization": 'Bearer ${globals.token}' };

    var resp = await http.post(url, headers: header);
    print(resp);
    setState(() {
      response = resp.body;
    });

  }

  @override
  Widget build(BuildContext context) {
    testRequest();
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Visibility(
        visible: response != "",
        replacement: Text("No response for now"),
        child: Text("Response : $response"),
      ),
    );
  }
}
