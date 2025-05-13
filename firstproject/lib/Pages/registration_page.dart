import 'package:flutter/material.dart';
import 'package:firstproject/Services/auth_service.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectRole = "User";

  void registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill in both email and password."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await AuthService().registerUser(
      email,
      password,
      selectRole,
    );

    print("Register response: $response"); // Debug print
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));

    if (response == "Verification email sent. Please verify before logging in.") {
      print("Redirecting to LoginPage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 15),
            DropdownButton<String>(
              value: selectRole,
              onChanged: (value) => setState(() => selectRole = value!),
              items: ["User", "Admin"]
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text("Register"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
