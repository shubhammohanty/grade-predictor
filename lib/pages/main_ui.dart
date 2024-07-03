import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/routes.dart';
import 'dart:developer' as devtools show log;
import 'dart:math';

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

  String calculateRelativeGrade(List<double> scores, double personScore) {
    int n = scores.length;

    // Calculate the mean
    double mean = scores.reduce((a, b) => a + b) / n;

    // Calculate the standard deviation
    double variance =
        scores.map((score) => pow(score - mean, 2)).reduce((a, b) => a + b) / n;
    double sd = sqrt(variance);

    // Determine the grade
    if (personScore >= mean + 1.5 * sd) {
      return 'A';
    } else if (personScore >= mean + 1.0 * sd) {
      return 'B+';
    } else if (personScore >= mean + 0.5 * sd) {
      return 'B';
    } else if (personScore >= mean) {
      return 'C+';
    } else if (personScore >= mean - 0.5 * sd) {
      return 'C';
    } else if (personScore >= mean - 1.0 * sd) {
      return 'D+';
    } else if (personScore >= mean - 1.5 * sd) {
      return 'D';
    } else {
      return 'F';
    }
  }

  String calculateAbsoluteGrade(double score) {
    score *= 100;
    if (score >= 90) {
      return 'A';
    } else if (score >= 80) {
      return 'B+';
    } else if (score >= 70) {
      return 'B';
    } else if (score >= 60) {
      return 'C+';
    } else if (score >= 50) {
      return 'C';
    } else if (score >= 40) {
      return 'D+';
    } else if (score >= 30) {
      return 'D';
    } else {
      return 'F';
    }
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
        gradeRelative =
            calculateRelativeGrade(tempgrade, currentUserTotalOfOne);
        gradeAbsolute = calculateAbsoluteGrade(currentUserTotalOfOne);

        coursesWithGrades.add({
          'course': course,
          'gradeRelative': gradeRelative,
          'gradeAbsolute': gradeAbsolute,
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
        backgroundColor: const Color(0xFF17171a),
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
                          mainUIRoute, (route) => false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
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
                            text: "Hello ",
                            style: TextStyle(
                                color: Color(0xFFF6F9FE),
                                fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: "There",
                            style: TextStyle(
                                color: Color(0xFFF6F9FE),
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: const Text(
                      "Never Underestimate Yourself! See you've come this far",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB9BEC6),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.only(left: 25),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Your Courses",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            institute == null
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: coursesWithGrades.length,
                      itemBuilder: (context, index) {
                        var courseInfo = coursesWithGrades[index];
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[600]),
                          child: ListTile(
                            leading: const Icon(
                              Icons.book_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            title: Text(
                              courseInfo['course'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Relative: ${courseInfo['gradeRelative']}   |",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "   Absolute: ${courseInfo['gradeAbsolute']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Text(
                                  "No. of people who added this course: ${courseInfo['count']}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  deleteCourse(courseInfo['course']),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  newCoursePageRoute,
                                  arguments: courseInfo['course']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: const Center(child: Icon(Icons.add_rounded, size: 40,)),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(newCoursePageRoute);
              },
            )
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
