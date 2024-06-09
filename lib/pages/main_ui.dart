import 'package:flutter/material.dart';

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainUI'),
      ),
      body: Column(
        children: [
          const Text("This is the main UI page of the app"),
          const Text('click below to logout'),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/settings/',
                  (route) => false,
                );
              },
              child: const Text('Click for settings'))
        ],
      ),
    );
  }
}
