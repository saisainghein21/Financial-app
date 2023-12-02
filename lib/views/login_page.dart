import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/my_button.dart';
import '../views/my_textfield.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, superkey, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF006DB6),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),

        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04102A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Image.asset(
                  'images/galaxy-logo.jpg', // Replace with the path to your logo image
                  width: 70, // Adjust the width as needed
                  height: 70, // Adjust the height as needed
                ),

                const SizedBox(height: 10),

                // welcome back, you've been missed!
                const Text(
                  'Galaxy Ray',
                  style: TextStyle(
                    color: Color(0xFFC201F2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),



                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),


                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: RichText(
                            text: const TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFC201F2),
                                decorationThickness: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
