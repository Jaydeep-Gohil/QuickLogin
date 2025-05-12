import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void logout(BuildContext context) {
    _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
        LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), actions: [
        IconButton(icon: Icon(Icons.logout), onPressed: () =>
            logout(context))
      ]),
      body: Center(child: Text("Welcome to Home Page!")),
    );
  }
}