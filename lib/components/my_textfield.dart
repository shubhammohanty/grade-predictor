import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.autocorrect,
    required this.enableSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        decoration: InputDecoration(
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide:const BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide:const BorderSide(color: Color.fromARGB(255, 50, 50, 50)),
            ),
            fillColor: const Color.fromARGB(255, 28, 28, 28),
            filled: true,
            hintText: hintText,
            hintStyle:const TextStyle(color: Color.fromARGB(255, 97, 97, 97) )),
      ),
    );
  }
}
