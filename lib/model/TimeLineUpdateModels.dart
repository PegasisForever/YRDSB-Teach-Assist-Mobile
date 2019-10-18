
import 'dart:convert';

import 'package:ta/model/Mark.dart';
import 'package:ta/network/network.dart';
import 'package:ta/prasers/ParsersCollection.dart';

import '../dataStore.dart';

class TAUpdate{
  DateTime time;
}

class AssignmentAdded extends TAUpdate{
  String courseName="";
  Assignment assignment;
  double assignmentAvg;
  double overallBefore;
  double overallAfter=0.0;
}

class AssignmentUpdated extends TAUpdate{
  String courseName="";
  String assignmentName="";
  Assignment assignmentBefore;
  Assignment assignmentAfter;
}

class CourseArchived extends TAUpdate{

}

class CourseAdded extends TAUpdate{
  var courseName="";
  var courseBlock="";
}

class CourseRemoved extends TAUpdate{
  var courseName="";
  var courseBlock="";
}

List<TAUpdate> getTimelineOf(String number){
  var str=prefs.getString("$number-timeline");
  if (str!=null){
    var json=jsonDecode(str);
    var version=prefs.getInt("$number-timeline-ver")??2;
    return JSONTimelineParsers[version](json);
  }else{
    return List<TAUpdate>();
  }
}

saveTimelineOf(String number,String json){
  prefs.setString("$number-timeline", json);
  prefs.setInt("$number-timeline-ver", apiVersion);
}