import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase/models/user_model.dart'; // Import UserModel to handle authentication
import 'package:awesome_dialog/awesome_dialog.dart';

class AuthController {
  // Static method for signing in a user
  static Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      // Attempt to sign in with FirebaseAuth using the provided email and password
      User? user = await UserModel.signIn(email, password); // Get the User from UserModel
      if (user != null) {
        // If sign-in is successful, navigate to the homepage
        Navigator.pushReplacementNamed(context, 'homepage');
      }
    } catch (e) {
      // Show error message if sign-in fails
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        closeIcon: const Icon(Icons.close_fullscreen_outlined),
        title: 'Login Failed',
        desc: e.toString(),
      ).show();
    }
  }

  // Static method for signing up a new user
  static Future<String?> signUp(BuildContext context, String email, String password) async {
    try {
      // Attempt to sign up the user using FirebaseAuth through UserModel
      User? user = await UserModel.signUp(email, password); // Get the User from UserModel
      if (user != null) {
        // If sign-up is successful, navigate to the login page
        Navigator.pushReplacementNamed(context, 'login');
        return user.uid;
      }
      else {
        return "x";
      }
    } catch (e) {
      // Show error message if sign-up fails
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        closeIcon: const Icon(Icons.close_fullscreen_outlined),
        title: 'Sign Up Failed',
        desc: e.toString(),
      ).show();
    }
  }

  // Static method for signing out the user
  static Future<void> signOut(BuildContext context) async {
    await UserModel.signOut(); // Sign the user out using the UserModel
    Navigator.pushReplacementNamed(context, 'login'); // Navigate back to login page after sign-out
  }
}
