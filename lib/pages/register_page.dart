import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart'; //necessary for firebase authentication
import 'package:gp/constants/routes.dart';
import 'package:gp/firebase_options.dart'; //necessary for firebase app initialization
import 'dart:ui' as ui;
import 'dart:developer' as devtools show log;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  late final TextEditingController
      _email; //late tells that we're going to assign value to this variable before using it
  late final TextEditingController
      _password; //TextEditingController creates a listener for text
  late final TextEditingController _confirmpassword;

  @override
  void initState() {
    //initializes the controllers
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //disposes off the value inside controllers after use to avoid privacy problems
    _email.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  // sign user in method
  void registerUserIn() async {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    final email = _email.text;
    final password = _password.text;
    final confirmpassword = _confirmpassword.text;
    try {
      if (!regex.hasMatch(password)) {
        //alert that password not strong
      } else if (password != confirmpassword) {
        //alert that passwords do not match
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email, password: password); //registering the user
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        devtools.log("account already exists");// alert that email already registered
      } else if (e.code == 'invalid-email') {
       devtools.log("invalid email"); // alert the user that email is invalid
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
          "Hello, \nGet Started",
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
        )
          ),
        ),
        
                const SizedBox(height: 25),
        
                // email textfield
                MyTextField(
                  controller: _email,
                  hintText: 'Enter your email',
                  obscureText:
                      false, //whether to hide the entered text using bullet dots
                  autocorrect: true,
                  enableSuggestions: true,
                ),
        
                const SizedBox(height: 15),
        
                // password textfield
                MyTextField(
                  controller: _password,
                  hintText: 'Create Password',
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
        
                const SizedBox(height: 15),
        
                // confirm password textfield
                MyTextField(
                  controller: _confirmpassword,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
        
                const SizedBox(height: 45),
        
                // sign in button
                GestureDetector(
                  onTap: registerUserIn,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 40),
        
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil( //routes user to login_page.dart
                            //routes user to register page
                            loginRoute,
                            (route) =>
                                false); //(route) => false tells flutter to push to a new page and also removed the last page
                      },
                      child: const Text(
                        'Login now', 
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
