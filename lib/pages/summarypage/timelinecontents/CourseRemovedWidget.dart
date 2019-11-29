import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';

import 'UpdateWidgetTitle.dart';

class CourseRemovedWidget extends StatelessWidget {
  final CourseRemoved update;

  CourseRemovedWidget(this.update) : super(key: Key(update.hashCode.toString()));

  @override
  Widget build(BuildContext context) {
    return UpdateWidgetTitle(
      subTitle: "Course Removed",
      title: update.courseName ?? "Unamed Course",
      icon: Icon(
        Icons.remove_circle,
        size: 32,
        color: Colors.amber[600],
      ),
    );
  }
}
