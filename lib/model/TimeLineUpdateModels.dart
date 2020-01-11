import 'dart:convert';

import 'package:quiver/core.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/prasers/ParsersCollection.dart';

class TAUpdate {
  DateTime time;
}

class AssignmentAdded extends TAUpdate {
  String courseName;
  Assignment assignment;
  double assignmentAvg;
  double overallBefore;
  double overallAfter = 0.0;

  @override
  int get hashCode =>
      hashObjects([time, courseName, assignment, assignmentAvg, overallBefore, overallAfter]);

  @override
  bool operator ==(other) {
    return other is AssignmentAdded &&
        time == other.time &&
        courseName == other.courseName &&
        assignment == other.assignment &&
        assignmentAvg == other.assignmentAvg &&
        overallBefore == other.overallBefore &&
        overallAfter == other.overallAfter;
  }
}

class AssignmentUpdated extends TAUpdate {
  String courseName;
  String assignmentName = "";
  Assignment assignmentBefore;
  double assignmentAvgBefore;
  double overallBefore;
  Assignment assignmentAfter;
  double assignmentAvgAfter;
  double overallAfter;

  @override
  int get hashCode => hashObjects([
        time,
        courseName,
        assignmentName,
        assignmentBefore,
        assignmentAvgBefore,
        overallBefore,
        assignmentAfter,
        assignmentAvgAfter,
        overallAfter,
      ]);

  @override
  bool operator ==(other) {
    return other is AssignmentUpdated &&
        time == other.time &&
        courseName == other.courseName &&
        assignmentName == other.assignmentName &&
        assignmentBefore == other.assignmentBefore &&
        assignmentAvgBefore == other.assignmentAvgBefore &&
        overallBefore == other.overallBefore &&
        assignmentAfter == other.assignmentAfter &&
        assignmentAvgAfter == other.assignmentAvgAfter &&
        overallAfter == other.overallAfter;
  }
}

class CourseArchived extends TAUpdate {}

class CourseAdded extends TAUpdate {
  String courseName;
  String courseBlock;

  @override
  int get hashCode => hash3(time, courseName, courseBlock);

  @override
  bool operator ==(other) {
    return other is CourseAdded &&
        time == other.time &&
        courseName == other.courseName &&
        courseBlock == other.courseBlock;
  }
}

class CourseRemoved extends TAUpdate {
  String courseName;
  String courseBlock;

  @override
  int get hashCode => hash3(time, courseName, courseBlock);

  @override
  bool operator ==(other) {
    return other is CourseAdded &&
        time == other.time &&
        courseName == other.courseName &&
        courseBlock == other.courseBlock;
  }
}

List<TAUpdate> getTimelineOf(String number) {
  var json = jsonDecode(prefs.getString("$number-timeline") ?? "[]");
  return parseTimeLine(json);
}

saveTimelineOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-timeline", jsonEncode(json));
}
