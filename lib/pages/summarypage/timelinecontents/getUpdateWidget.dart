import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/summarypage/timelinecontents/AssignmentAddedWidget.dart';
import 'package:ta/pages/summarypage/timelinecontents/AssignmentUpdatedWidget.dart';
import 'package:ta/pages/summarypage/timelinecontents/CourseAddedWidget.dart';
import 'package:ta/pages/summarypage/timelinecontents/CourseRemovedWidget.dart';

Widget getUpdateWidget(TAUpdate update, Map weightTableMap) {
  if (update is AssignmentAdded) {
    return AssignmentAddedWidget(update, weightTableMap);
  } else if (update is AssignmentUpdated) {
    return AssignmentUpdatedWidget(update, weightTableMap);
  } else if (update is CourseAdded) {
    return CourseAddedWidget(update);
  } else if (update is CourseRemoved) {
    return CourseRemovedWidget(update);
  } else {
    print(update);
    return null;
  }
}
