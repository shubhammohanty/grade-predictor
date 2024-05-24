import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp/firebase_options.dart';
import 'dart:ui' as ui;

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
    await Firebase.initializeApp(
      //firebase app initialization
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final email = _email.text;
    final password = _password.text;
    try {
      final userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password); //registering the user
      print(userCredentials);
      print("doneeeeeeeeeeeeeeeeeeeeee");
    } on FirebaseAuthException catch (e) {
      print(e);
      print("invalid credsssssssssssss"); //giveout error that invalid credentials
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
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
        const Offset(0, 50),
        const Offset(180, 20),
        <Color>[
          const Color.fromARGB(255, 255, 255, 255),
          const Color.fromARGB(255, 73, 73, 73),
        ],
      )
  ),
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
                        Navigator.of(context).pushNamedAndRemoveUntil(    //routes user to register_page.dart
                          '/forgotpass/', (route) => false);
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
                      Navigator.of(context).pushNamedAndRemoveUntil(    //routes user to register_page.dart
                          '/register/', (route) => false); //(route) => false tells flutter to push to a new page and also removed the last page
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
      ),
    );
  }
}
