import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/updatespage/updatecontents/AssignmentAddedWidget.dart';
import 'package:ta/pages/updatespage/updatecontents/AssignmentUpdatedWidget.dart';
import 'package:ta/pages/updatespage/updatecontents/CourseAddedWidget.dart';
import 'package:ta/pages/updatespage/updatecontents/CourseRemovedWidget.dart';

Widget getUpdateWidget(TAUpdate update) {
  if (update is AssignmentAdded) {
    return AssignmentAddedWidget(update);
  } else if (update is AssignmentUpdated) {
    return AssignmentUpdatedWidget(update);
  } else if (update is CourseAdded) {
    return CourseAddedWidget(update);
  } else if (update is CourseRemoved) {
    return CourseRemovedWidget(update);
  } else {
    print(update);
    return null;
  }
}
