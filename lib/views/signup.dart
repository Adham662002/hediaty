import 'package:flutter/material.dart';
import 'package:firebase/widgets/custom_button_auth.dart';
import 'package:firebase/controllers/auth_controller.dart';
import 'package:firebase/controllers/user_controller.dart';
import 'package:firebase/widgets/custom_textform.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple],
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
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
                CustomTextForm(hinttext: "Enter Your Username", mycontroller: username),

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),
                const Text(
                  "phone",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
                CustomTextForm(hinttext: "Enter Your phone", mycontroller: phone),

                const SizedBox(height: 20),
                CustomButtonAuth(
                  title: "Sign Up",
                  onPressed: () async{
                    String? id =await AuthController.signUp(context, email.text, password.text);
                    UserController.addUser(userId: id!, username: username.text, email: email.text, phone: phone.text);
                  },
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.white70)),
                        TextSpan(
                          text: "Login",
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
