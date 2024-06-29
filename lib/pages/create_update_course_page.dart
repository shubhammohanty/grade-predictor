import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp/components/my_textfield.dart';
import 'dart:developer' as devtools show log;

import 'package:gp/utilities/generics/get_Arguments.dart';

class NewCoursePage extends StatefulWidget {
  const NewCoursePage({super.key});

  @override
  State<NewCoursePage> createState() => _NewCoursePageState();
}

class _NewCoursePageState extends State<NewCoursePage> {
  late final TextEditingController _courseId;
  late final TextEditingController _quizObt;
  late final TextEditingController _quizTotal;
  late final TextEditingController _midsemObt;
  late final TextEditingController _midsemTotal;
  late final TextEditingController _endsemObt;
  late final TextEditingController _endsemTotal;
  late final TextEditingController _assmntObt;
  late final TextEditingController _assmntTotal;

  @override
  void initState() {
    _courseId = TextEditingController();
    _quizObt = TextEditingController();
    _quizTotal = TextEditingController();
    _midsemObt = TextEditingController();
    _midsemTotal = TextEditingController();
    _endsemObt = TextEditingController();
    _endsemTotal = TextEditingController();
    _assmntObt = TextEditingController();
    _assmntTotal = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _quizObt.dispose();
    _quizTotal.dispose();
    _midsemObt.dispose();
    _midsemTotal.dispose();
    _endsemObt.dispose();
    _endsemTotal.dispose();
    _assmntObt.dispose();
    _assmntTotal.dispose();
    super.dispose();
  }

  Future<void> checkNewOrExists(BuildContext context) async {
    final courseIDarg = context.getArgument<String>();
    if (courseIDarg != null) {
      final docRef = FirebaseFirestore.instance
          .collection("iiserb")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection(courseIDarg.toString())
          .doc('analytics');
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          _courseId.text = courseIDarg.toString();
          _quizObt.text = data['quizObt'].toString();
          _quizTotal.text = data['quizTotal'].toString();
          _midsemObt.text = data['midsemObt'].toString();
          _midsemTotal.text = data['midsemTotal'].toString();
          _endsemObt.text = data['endsemObt'].toString();
          _endsemTotal.text = data['endsemTotal'].toString();
          _assmntObt.text = data['assmntObt'].toString();
          _assmntTotal.text = data['assmntTotal'].toString();
        },
        onError: (e) => devtools.log(e),
      );

      //set textcontroller values by fetching from firestore
    } else {
      _quizObt.text = '0';
      _quizTotal.text = '0';
      _midsemObt.text = '0';
      _midsemTotal.text = '0';
      _endsemObt.text = '0';
      _endsemTotal.text = '0';
      _assmntObt.text = '0';
      _assmntTotal.text = '0';
    }
  } //add logic

  void createorupdatecourse() async {
    try {
      if (double.parse(_quizObt.text.toString()) <=
              double.parse(_quizTotal.text.toString()) &&
          double.parse(_midsemObt.text.toString()) <=
              double.parse(_midsemTotal.text.toString()) &&
          double.parse(_endsemObt.text.toString()) <=
              double.parse(_endsemTotal.text.toString()) &&
          double.parse(_assmntObt.text.toString()) <=
              double.parse(_assmntTotal.text.toString())) {
        CollectionReference colRef =
            FirebaseFirestore.instance.collection("iiserb");
await colRef
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .update({
                          "courses": FieldValue.arrayUnion([_courseId.text]),
                        });

                        await colRef
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .collection(_courseId.text.toString())
                            .doc('analytics')
                            .set(<String, dynamic>{
                          "quizObt": double.parse(_quizObt.text),
                          "quizTotal": double.parse(_quizTotal.text),
                          "midsemObt": double.parse(_midsemObt.text),
                          "midsemTotal": double.parse(_midsemTotal.text),
                          "endsemObt": double.parse(_endsemObt.text),
                          "endsemTotal": double.parse(_endsemTotal.text),
                          "assmntObt": double.parse(_assmntObt.text),
                          "assmntTotal": double.parse(_assmntTotal.text),
                          "totalOfOne": ((double.parse(_quizObt.text) +
                                  double.parse(_midsemObt.text) +
                                  double.parse(_endsemObt.text) +
                                  double.parse(_assmntObt.text)) /
                              (double.parse(_quizTotal.text) +
                                  double.parse(_midsemTotal.text) +
                                  double.parse(_endsemTotal.text) +
                                  double.parse(_assmntTotal.text))),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Values Saved Successfully"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);


        /*       await colRef
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection(_courseId.text.toString())
            .doc('analytics')
            .set(<String, dynamic>{
          "quizObt": double.parse(_quizObt.text),
          "quizTotal": double.parse(_quizTotal.text),
          "midsemObt": double.parse(_midsemObt.text),
          "midsemTotal": double.parse(_midsemTotal.text),
          "endsemObt": double.parse(_endsemObt.text),
          "endsemTotal": double.parse(_endsemTotal.text),
          "assmntObt": double.parse(_assmntObt.text),
          "assmntTotal": double.parse(_assmntTotal.text),
          "totalOfOne": ((double.parse(_quizObt.text) +
                  double.parse(_midsemObt.text) +
                  double.parse(_endsemObt.text) +
                  double.parse(_assmntObt.text)) /
              (double.parse(_quizTotal.text) +
                  double.parse(_midsemTotal.text) +
                  double.parse(_endsemTotal.text) +
                  double.parse(_assmntTotal.text))),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Values Saved Successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);*/
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Value Found"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ohh Oo! There's Some Issue"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.black,
        title:
            const Text('Add New Course', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: checkNewOrExists(context),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 32, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Course Name',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter the name of your course without spaces',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _courseId,
                    hintText: 'Example: PHY302',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total marks you got in all quizzes combined',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Combine the total marks you got in all quizzes conducted and enter it below',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _quizObt,
                    hintText: 'Example: 25',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Your quizzes combined were out of ?',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter what marks your quizzes all combined were out of',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _quizTotal,
                    hintText: 'Example: 30',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Marks you got in Midsem',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter the marks you got in your midsem exam',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _midsemObt,
                    hintText: 'Example: 45',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Your Midsem was out of ?',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter what marks your midsem exam was out of',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _midsemTotal,
                    hintText: 'Example: 50',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Marks you got in Endsem',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter the marks you got in your endsem exam',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _endsemObt,
                    hintText: 'Example: 85',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Your Endsem was out of ?',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter what marks your endsem exam was out of',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _endsemTotal,
                    hintText: 'Example: 100',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total Marks you got in all assignments combined',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter the total marks you got in all assignments combined',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _assmntObt,
                    hintText: 'Enter value',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Your assignments were out of ?',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Tooltip(
                          message:
                              'Enter what marks your assignments all combined were out of',
                          showDuration: Duration(seconds: 3),
                          textStyle: TextStyle(color: Colors.white),
                          preferBelow: false,
                          verticalOffset: 20,
                          child:
                              Icon(Icons.info, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _assmntTotal,
                    hintText: 'Enter value',
                    obscureText: false,
                    autocorrect: true,
                    enableSuggestions: true,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: createorupdatecourse,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          }),
    );
  }
}
