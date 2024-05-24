import 'package:flutter/material.dart';

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is the main UI page of the app"),
      ),
    );
  }
}