import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
    Icons.chevron_left,
    color: Colors.black,
    size: 40.0,
  ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
          ),
        ),
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
                print(FirebaseAuth.instance.currentUser);
               await FirebaseAuth.instance.signOut();
                print('------------------------------------------------------');
                print(FirebaseAuth.instance.currentUser);
                Navigator.of(context).pop(true);
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
                
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