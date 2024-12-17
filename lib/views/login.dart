import 'package:flutter/material.dart';
import 'package:firebase/widgets/custom_button_auth.dart';
import 'package:firebase/controllers/auth_controller.dart';
import 'package:firebase/widgets/custom_textform.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your details to login",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
                CustomTextForm(hinttext: "Enter Your Email", mycontroller: email),

                const SizedBox(height: 20),

                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
                CustomTextForm(hinttext: "Enter Your Password", mycontroller: password),

                const SizedBox(height: 40),

                CustomButtonAuth(
                  title: "Login",
                  onPressed: () {
                    AuthController.signIn(context, email.text, password.text);
                  },
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("signup");
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: "Don't Have An Account? ", style: TextStyle(color: Colors.white70)),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
