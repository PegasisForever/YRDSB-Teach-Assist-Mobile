import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';

class ArchivedCoursesPage extends StatefulWidget {
  @override
  _ArchivedCoursesPageState createState() => _ArchivedCoursesPageState();
}

class _ArchivedCoursesPageState extends State<ArchivedCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("archived_marks")),
      ),
      body: Center(
        child: Text(Strings.get("no_archived_courses"), style: Theme
            .of(context)
            .textTheme
            .subhead,),
      ),
    );
  }
}
