import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for authentication

class UserModel {
  // Static method to handle user sign-up
  static Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Error during sign-up: $e');
    }
  }

  // Static method to handle user sign-in
  static Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Error during sign-in: $e');
    }
  }

  // Static method to handle user sign-out
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut(); // Sign out the current user
  }
}
