import 'package:firebase_core/firebase_core.dart';
import 'package:firstproject/Pages/registration_page.dart';
import 'package:flutter/material.dart';

import 'Pages/login_page.dart';
import 'Pages/home_page.dart';
import 'Pages/profile_page.dart';     // NEW
import 'Pages/settings_page.dart';
import 'package:firstproject/Pages/todo_page.dart' as todo;    // NEW

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
      initialRoute: '/login',
      routes: {
        '/login':  (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),      // NEW
        '/settings': (context) => SettingsPage(),  // NEW
        '/todo': (context) => todo.TodoPage(),
      },
    );
  }
}
