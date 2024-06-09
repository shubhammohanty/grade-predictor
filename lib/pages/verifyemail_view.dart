import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
         const Text("This is the email verification view"),
          TextButton(onPressed:() async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification Link Sent"),
            behavior: SnackBarBehavior.floating,
          ), //giveout error that invalid credentials
        );

          }, child: const Text("email Verification link")),
        ],
      )
    );
  }
}