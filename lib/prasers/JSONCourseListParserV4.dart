import 'package:flutter/foundation.dart' hide Category;
import 'package:ta/model/Mark.dart';

SmallMarkGroup _parseSmallMarkGroup(Map<String, dynamic> json) {
  var smallMark = SmallMark.blank();
  smallMark.finished = json["finished"];
  smallMark.total = json["total"];
  smallMark.get = json["get"];
  smallMark.weight = json["weight"];

  return SmallMarkGroup.blank()..smallMarks.add(smallMark);
}

Assignment parseAssignment(Map<String, dynamic> json) {
  var assignment = Assignment.blank();

  assignment.name = json["name"];
  assignment.feedback = json["feedback"];
  assignment.time = json["time"] != null ? DateTime.parse(json["time"]) : null;
  for (final category in Category.values) {
    String categoryName = describeEnum(category);
    assignment[category] = json.containsKey(categoryName)
        ? _parseSmallMarkGroup(json[categoryName])
        : SmallMarkGroup.blank();
  }
  return assignment;
}

Weight _parseWeight(Map<String, dynamic> json) {
  var weight = Weight.blank();

  weight.W = json["W"];
  weight.CW = json["CW"];
  weight.SA = json["SA"];

  return weight;
}

WeightTable _parseWeightTable(Map<String, dynamic> json) {
  var weightTable = WeightTable.blank();
  for (final category in Category.values) {
    weightTable[category] = _parseWeight(json[describeEnum(category)]);
  }
  return weightTable;
}

Course _parseCourse(Map<String, dynamic> json) {
  var course = Course.blank();

  course.startTime = json["start_time"] != null ? DateTime.parse(json["start_time"]) : null;
  course.endTime = json["end_time"] != null ? DateTime.parse(json["end_time"]) : null;
  course.name = json["name"];
  course.code = json["code"];
  course.block = json["block"];
  course.room = json["room"];
  course.overallMark = json["overall_mark"];
  course.cached = json["cached"];

  if (course.overallMark != null) {
    course.weightTable = _parseWeightTable(json["weight_table"]);
    course.assignments = List<Assignment>();
    for (Map<String, dynamic> assignment in json["assignments"]) {
      course.assignments.add(parseAssignment(assignment));
    }
  }

  return course;
}

List<Course> parseJSONCourseList(List<dynamic> json) {
  var courses = List<Course>();

  json.forEach((courseJSON) {
    courses.add(_parseCourse(courseJSON));
  });

  return courses;
}
