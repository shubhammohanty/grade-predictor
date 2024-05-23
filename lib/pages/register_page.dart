import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart'; //necessary for firebase authentication
import 'package:gp/firebase_options.dart'; //necessary for firebase app initialization

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

    await Firebase.initializeApp(
      //firebase app initialization
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final email = _email.text;
    final password = _password.text;
    final confirmpassword = _confirmpassword.text;
    try {
      if (!regex.hasMatch(password)) {
        //alert that password not strong
      } else if (password != confirmpassword) {
        //alert that passwords do not match
      } else {
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email, password: password); //registering the user
        print(userCredentials); 
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // alert that email already registered
      }
      else if(e.code == 'invalid-email'){
        // alert the user that email is invalid
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello, \nGet Started", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 50,fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

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

              const SizedBox(height: 50),

              // sign in button
              GestureDetector(
                onTap: registerUserIn,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
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
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Login now', //needs to be routed to signup_page.dart
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
