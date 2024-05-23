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
              borderSide:const BorderSide(color: Color.fromARGB(255, 238, 240, 240)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide:const BorderSide(color: Color.fromARGB(255, 236, 240, 240)),
            ),
            fillColor: const Color(0xffF7F7F7),
            filled: true,
            hintText: hintText,
            hintStyle:const TextStyle(color: Color.fromARGB(255, 148, 148, 149) )),
      ),
    );
  }
}
