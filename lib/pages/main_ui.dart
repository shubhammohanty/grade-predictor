
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';

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
          const Text('click below for settings'),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(settingsRoute);
              },
              child: const Text('Click for settings')),
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(newCoursePageRoute, arguments: 'PHY101');
          }, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
