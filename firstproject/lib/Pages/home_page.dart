import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:firstproject/Services/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userRole = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUserRole();
  }

  void loadUserRole() async {
    String role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  void logout() async {
    await AuthService().logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
        LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home - $userRole"),
      actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Text(userRole=="Admin" ? "Welcome, Admin! Manage Users.":"welcome, User! Browse Contenr"),
      ),
    );
  }

}