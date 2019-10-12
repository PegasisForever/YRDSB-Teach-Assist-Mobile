import 'package:ta/model/Mark.dart';


SmallMark _parseSmallMark(Map<String, dynamic> json){
  var smallMark=SmallMark.blank();

  if (json["available"]){
    smallMark.available=true;
    smallMark.finished=json["finished"];
    smallMark.total=json["total"];
    smallMark.get=json["get"];
    smallMark.weight=json["weight"];
  }else{
    smallMark.available=false;
  }

  return smallMark;
}

Assignment _parseAssignment(Map<String, dynamic> json){
  var assignment=Assignment.blank();

  assignment.name=json["name"];
  if (json["time"]!=""){
    assignment.time=DateTime.parse(json["time"]);
  }
  assignment.KU=_parseSmallMark(json["KU"]);
  assignment.T=_parseSmallMark(json["T"]);
  assignment.C=_parseSmallMark(json["C"]);
  assignment.A=_parseSmallMark(json["A"]);
  assignment.O=_parseSmallMark(json["O"]);
  assignment.F=_parseSmallMark(json["F"]);

  return assignment;
}

Weight _parseWeight(Map<String, dynamic> json){
  var weight=Weight.blank();

  if (json.containsKey("W")){
    weight.W=json["W"];
  }
  weight.CW=json["CW"];
  weight.SA=json["SA"];

  return weight;
}

WeightTable _parseWeightTable(Map<String, dynamic> json){
  var weightTable=WeightTable.blank();

  weightTable.KU=_parseWeight(json["KU"]);
  weightTable.T=_parseWeight(json["T"]);
  weightTable.C=_parseWeight(json["C"]);
  weightTable.A=_parseWeight(json["A"]);
  weightTable.O=_parseWeight(json["O"]);
  weightTable.F=_parseWeight(json["F"]);

  return weightTable;
}

Course _parseCourse(Map<String, dynamic> json){
  var course=Course.blank();

  course.startTime=DateTime.parse(json["start_time"]);
  course.endTime=DateTime.parse(json["end_time"]);
  course.name=json["name"];
  course.code=json["code"];
  course.block=json["block"];
  course.room=json["room"];
  course.overallMark=json["overall_mark"];

  Map<String, dynamic> markDetail=json["mark_detail"];
  if (markDetail.length==2){
    course.weightTable=_parseWeightTable(markDetail["weights"]);
    for (Map<String, dynamic> assignment in markDetail["assignments"]){
      course.assignments.add(_parseAssignment(assignment));
    }
  }

  return course;
}


List<Course> parseJSONCourseList(List<dynamic> json){
  var courses=List<Course>();

  json.forEach((courseJSON){
    courses.add(_parseCourse(courseJSON));
  });

  return courses;
}