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
          fetchCoursesAndGrades();
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch institute name.';
          devtools.log(errorMessage);
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching institute: $error';
        devtools.log(errorMessage);
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
        for (String course in courses) {
          await fetchGradeForCourse(course);
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching courses and grades: $error';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error fetching courses and grades"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        devtools.log(errorMessage);
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

    for (var doc in querySnapshot.docs) {
      DocumentSnapshot analyticsSnapshot = await FirebaseFirestore.instance
          .collection(institute!)
          .doc(doc.id)
          .collection(course)
          .doc('analytics')
          .get();

      if (analyticsSnapshot.exists) {
        double totalOfOne = analyticsSnapshot['totalOfOne'];
        tempgrade.add(totalOfOne);
      }
    }

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

        coursesWithGrades.add({
          'course': course,
          'gradeRelative': gradeRelative,
          'count': courseCount
        });
      }
    }
  }

  Future<void> deleteCourse(String course) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Caution'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Proceed with deletion
                if (institute == null) return;

                try {
                  // Remove the course from the courses array
                  DocumentReference userDocRef = FirebaseFirestore.instance
                      .collection(institute!)
                      .doc(FirebaseAuth.instance.currentUser?.email);

                  await userDocRef.update({
                    'courses': FieldValue.arrayRemove([course])
                  });

                  // Delete the subcollection
                  QuerySnapshot subcollectionSnapshot =
                      await userDocRef.collection(course).get();

                  for (DocumentSnapshot doc in subcollectionSnapshot.docs) {
                    await doc.reference.delete();
                  }

                  // Optionally, update the local state if needed
                  setState(() {
                    coursesWithGrades.removeWhere(
                        (courseInfo) => courseInfo['course'] == course);
                  });
                } catch (error) {
                  setState(() {
                    errorMessage = 'Error deleting course $course: $error';
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error Deleting Course"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    devtools.log(errorMessage);
                  });
                }
              },
            ),
          ],
        );
      },
    );
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
                      child:
                          Icon(Icons.settings, size: 30, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          mainUIRoute,
                          (route) => false);
                    },
                  ),
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
                            fontSize: 35,
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
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: coursesWithGrades.length,
                      itemBuilder: (context, index) {
                        var courseInfo = coursesWithGrades[index];
                        return ListTile(
                          tileColor: Colors.white,
                          leading: const Icon(Icons.book),
                          title: Text(courseInfo['course']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Relative Grade: ${courseInfo['gradeRelative']}"),
                              Text("Count: ${courseInfo['count']} documents"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteCourse(courseInfo['course']),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(newCoursePageRoute,
                                arguments: courseInfo['course']);
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
