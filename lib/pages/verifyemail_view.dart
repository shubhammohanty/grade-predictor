import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Verify email"),
      ),
      body: Column(
        children: [
         const Text("If you did not receive the mail automatically, click on the link below"),
          TextButton(onPressed:() async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification Link Sent"),
            behavior: SnackBarBehavior.floating,
          ), //giveout error that invalid credentials
        );

          }, child: const Text("send email")),
          const Text("If you've verified your email, click continue below"),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil( //routes user to login_page.dart
                            loginRoute,
                            (route) =>
                                false);
          }, child: const Text("Continue"),)
        ],
      )
    );
  }
}