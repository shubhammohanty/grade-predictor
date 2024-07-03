import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';
import 'dart:developer' as devtools show log;

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  String? institute;
  List<Map<String, dynamic>> coursesWithGrades = [];
  bool isLoading = true;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();
    fetchInstitute().then((value) {
      if (value != null) {
        setState(() {
          institute = value;
          devtools.log("institute name: ${institute}");
          fetchCoursesAndGrades();
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch institute name.';
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching institute: $error';
      });
    });
  }
  Future<void> fetchCoursesAndGrades() async {
    if (institute == null) return;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(institute!)
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();

      if (snapshot.exists) {
        List<dynamic> courses = snapshot['courses'];
        devtools.log(courses.toString());
        for (String course in courses) {
          devtools.log(course);
          await fetchGradeForCourse(course);
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching courses and grades: $error';
      });
    } finally {
      setState(() {
        isLoading = false; // Ensure isLoading is set to false after fetching
      });
    }
  }

  Future<void> fetchGradeForCourse(String course) async {
    List<double> tempgrade = [];        
    String gradeRelative = "NA"; 
    String gradeAbsolute = "NA"; 
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(institute!)
        .where('courses', arrayContains: course)
        .get();

    int courseCount = querySnapshot.size;
    devtools.log(courseCount.toString());

    for (var doc in querySnapshot.docs) {
      DocumentSnapshot analyticsSnapshot = await FirebaseFirestore.instance
          .collection(institute!)
          .doc(doc.id)
          .collection(course)
          .doc('analytics')
          .get();

      if (analyticsSnapshot.exists) {
        double totalOfOne = analyticsSnapshot['totalOfOne'];
        devtools.log(totalOfOne.toString());
        tempgrade.add(totalOfOne);
      } 
    }
    devtools.log(tempgrade.toString());

    if (tempgrade.isNotEmpty) {
      DocumentSnapshot currentUserAnalytics = await FirebaseFirestore.instance
          .collection(institute!)
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection(course)
          .doc('analytics')
          .get();

      if (currentUserAnalytics.exists) {
        double currentUserTotalOfOne = currentUserAnalytics['totalOfOne'];
        //grade calculation

        coursesWithGrades.add({'course': course, 'gradeRelative': gradeRelative, 'count': courseCount});
        devtools.log(coursesWithGrades.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF131820),
        body: Column(
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
                   institute == null
          ? Center(child: CircularProgressIndicator())
          : Expanded(
                  child: ListView.builder(
                    itemCount: coursesWithGrades.length,
                    itemBuilder: (context, index) {
                      var courseInfo = coursesWithGrades[index];
                      return ListTile(
                        leading: Icon(Icons.book),
                        title: Text(courseInfo['course']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Relative: ${courseInfo['gradeRelative']}"),
                            Text("Count: ${courseInfo['count']} documents"),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).pushNamed(newCoursePageRoute, arguments: courseInfo['course']);
                        },
                      );
                    },
                  ),
                ),
                ],
              ),
            
      ),
    );
  }
}

Future<String?> fetchInstitute() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();

    if (snapshot.exists) {
      return snapshot['institute'];
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}