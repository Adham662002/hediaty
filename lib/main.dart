import 'package:firebase/views/login.dart';    // Correct import for Login
import 'package:firebase/views/signup.dart';     // Correct import for SignUp
import 'package:firebase/views/homepage.dart'; // Correct import for HomePage
import 'package:firebase/views/profile.dart';  // Correct import for ProfilePage
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth correctly
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is signed out');
      } else {
        print('User is signed in');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) => const HomePage(),
        "profile": (context) => const ProfilePage(),
      },
    );
  }
}
