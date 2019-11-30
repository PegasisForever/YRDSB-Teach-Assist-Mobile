
import 'dart:convert';

import 'package:ta/model/Mark.dart';
import 'package:ta/prasers/ParsersCollection.dart';

import '../dataStore.dart';

class TAUpdate{
  DateTime time;
}

class AssignmentAdded extends TAUpdate{
  String courseName;
  Assignment assignment;
  double assignmentAvg;
  double overallBefore;
  double overallAfter=0.0;
}

class AssignmentUpdated extends TAUpdate{
  String courseName;
  String assignmentName="";
  Assignment assignmentBefore;
  double assignmentAvgBefore;
  double overallBefore;
  Assignment assignmentAfter;
  double assignmentAvgAfter;
  double overallAfter;
}

class CourseArchived extends TAUpdate{

}

class CourseAdded extends TAUpdate{
  String courseName;
  String courseBlock;
}

class CourseRemoved extends TAUpdate{
  String courseName;
  String courseBlock;
}

List<TAUpdate> getTimelineOf(String number){
  var json = jsonDecode(prefs.getString("$number-timeline") ?? "[]");
  return parseTimeLine(json);
}

saveTimelineOf(String number,Map<String, dynamic> json){
  prefs.setString("$number-timeline", jsonEncode(json));
}