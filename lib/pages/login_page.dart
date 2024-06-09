import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp/constants/routes.dart';
import 'package:gp/firebase_options.dart';
import 'dart:ui' as ui;
import 'dart:developer' as devtools show log;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  late final TextEditingController _email;
  //late tells that we're going to assign value to this variable before using it
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // sign user in method
  void logUserIn() async {
    final email = _email.text;
    final password = _password.text;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ); //registering the user
      devtools.log('logged in successfully');
      Navigator.of(context).pushNamedAndRemoveUntil(
        homeRoute,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      devtools.log(e.toString());

      if (e.code == "invalid-credential" || e.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid Credentials"),
            behavior: SnackBarBehavior.floating,
          ), //giveout error that invalid credentials
        );
      } else if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network Error"),
            behavior: SnackBarBehavior.floating,
          ), 
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          //firebase app initialization
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello, \nWelcome Back",
                    style: GoogleFonts.varelaRound(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = ui.Gradient.linear(
                            const Offset(0, 120),
                            const Offset(180, 20),
                            <Color>[
                              const Color.fromARGB(255, 255, 255, 255),
                              const Color.fromARGB(255, 73, 73, 73),
                            ],
                          )),
                  ),

                  const SizedBox(height: 30),

                  // email textfield
                  MyTextField(
                    controller: _email,
                    hintText: 'Email',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),

                  const SizedBox(height: 15),

                  // password textfield
                  MyTextField(
                    controller: _password,
                    hintText: 'Password',
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              //routes user to register_page.dart
                              forgotPassRoute, (route) => false,
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // sign in button
                  GestureDetector(
                    onTap: logUserIn,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              //routes user to register_page.dart
                              registerRoute,
                              (route) =>
                                  false); //(route) => false tells flutter to push to a new page and also removed the last page
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
