import 'package:flutter/material.dart';

class ArchivedCoursesPage extends StatefulWidget {
  @override
  _ArchivedCoursesPageState createState() => _ArchivedCoursesPageState();
}

class _ArchivedCoursesPageState extends State<ArchivedCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archived Courses"),
      ),
      body: Center(
        child: Text("No archived courses."),
      ),
    );
  }
}
