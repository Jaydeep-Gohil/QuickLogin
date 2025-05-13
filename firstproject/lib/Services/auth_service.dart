import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with Email, Password & Role
  Future<String> registerUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure userCredential.user is not null
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'role': role,
          'verified': false,
        });

        return "Verification email sent. Please verify before logging in.";
      } else {
        return "Registration failed. User credential is null.";
      }
    } catch (e) {
      return "Registration failed: ${e.toString()}";
    }
  }

  // Login user
  Future<String> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return "Login failed: No user found.";
      }

      if (!userCredential.user!.emailVerified) {
        return "Please verify your email before logging in.";
      }

      return "Login Successful";
    } catch (e) {
      return "Login failed: ${e.toString()}";
    }
  }

  // Password reset
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset link sent to your email.";
    } catch (e) {
      return "Reset failed: ${e.toString()}";
    }
  }

  // Google Sign-in
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Cancelled";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return "Google Sign-In failed: No user data returned.";
      }

      // Check if user exists in Firestore, otherwise create a new record
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'User', // Default role for Google sign-ins
          'verified': true,
        });
      }

      return "Google Sign-In Successful";
    } catch (e) {
      return "Google Sign-In failed: ${e.toString()}";
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get Role
  Future<String> getUserRole() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return "No user logged in";

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc['role'] ?? 'User' : 'User';
  }
}
