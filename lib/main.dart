import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';
import 'package:gp/firebase_options.dart';
import 'package:gp/pages/forgot_pass_page.dart';
import 'package:gp/pages/login_page.dart';
import 'package:gp/pages/main_ui.dart';
import 'package:gp/pages/register_page.dart';
import 'package:gp/pages/settings_page.dart';
import 'package:gp/pages/verifyemail_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'grade-predictor',
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginPage(),
      registerRoute: (context) => const RegisterPage(),
      forgotPassRoute: (context) => const ForgotPassPage(),
      settingsRoute: (context) => const SettingsPage(),
      homeRoute: (context) => const HomePage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    //check if user's email is verified
                  return const MainUi();  
                  } else {
                    return const VerifyEmailPage();
                  }
                } else {
                  return const LoginPage();
                }
              default:
                return const Text("loading....");
            }
          });
  }
}
