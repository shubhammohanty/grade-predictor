import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';
import 'package:gp/firebase_options.dart';
import 'dart:developer' as devtools show log;

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  String instituteName = '';
final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email);
  Future<void> mainUIbuilder(BuildContext context) async {
    
    await userRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      instituteName = data["institute"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF131820),
        body: FutureBuilder(
            future: mainUIbuilder(context),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(settingsRoute);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.settings,
                                size: 30, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Hello There",
                                    style: TextStyle(
                                        color: Color(0xFFF6F9FE),
                                        fontWeight: FontWeight.w300),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: const Text(
                              "Never Underestimate Yourself! See you've come this far",
                              style: TextStyle(
                                color: Color(0xFFB9BEC6),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(instituteName)
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .snapshots(),
                      builder: (context, snapshot){
                        devtools.log(instituteName);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data available'));
                        }

                        var userDocument = snapshot.data!;
                        devtools.log(userDocument["userID"]);

                        return const Text('test');
                        /*return Expanded(
                          child: ListView.builder(
                              itemCount: 4,
                              itemBuilder: (ctx, index) {
                                return Container();
                              }),
                        );*/
                      })
                ],
              );
            }),
      ),
    );
  }
}
