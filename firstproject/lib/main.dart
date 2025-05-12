import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Pages/login_page.dart';
 // Import the login page
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Start with the login page
    );
  }
}