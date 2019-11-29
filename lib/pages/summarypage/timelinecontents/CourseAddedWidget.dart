import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';

import 'UpdateWidgetTitle.dart';

class CourseAddedWidget extends StatelessWidget {
  final CourseAdded update;

  CourseAddedWidget(this.update) : super(key: Key(update.hashCode.toString()));

  @override
  Widget build(BuildContext context) {
    return UpdateWidgetTitle(
      subTitle: "Course Added",
      title: update.courseName ?? "Unamed Course",
      icon: Icon(
        Icons.add_circle,
        size: 32,
        color: Colors.amber[600],
      ),
    );
  }
}
