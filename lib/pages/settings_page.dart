import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp/constants/routes.dart';

 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings Page'),),
        body: SingleChildScrollView(
          child: Column(
              children: [
               const Padding(
                  padding: EdgeInsets.all(20),),
                InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showLogOutDialog(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: const Icon(
                                  Icons.power_settings_new,
                                  size: 30.0,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(width: 100),
                              Text(
                                'Log Out',),
                              SizedBox(width: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      
  }
}


Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout from the App ?"),
        actions: [
          TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
               await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(true);
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logged Out"),
            behavior: SnackBarBehavior.floating,
          ), //giveout error that invalid credentials
        );
                
              },
            ),
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}