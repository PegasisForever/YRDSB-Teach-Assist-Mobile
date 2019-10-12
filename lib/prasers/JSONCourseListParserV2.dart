import 'package:ta/model/Mark.dart';

SmallMark _parseSmallMark(Map<String, dynamic> json) {
  var smallMark = SmallMark.blank();

  if (json["available"]) {
    smallMark.available = true;
    smallMark.finished = json["finished"];
    smallMark.total = json["total"];
    smallMark.get = json["get"];
    smallMark.weight = json["weight"];
  } else {
    smallMark.available = false;
  }

  return smallMark;
}

Assignment _parseAssignment(Map<String, dynamic> json) {
  var assignment = Assignment.blank();

  assignment.name = json["name"];
  if (json["time"] != "") {
    assignment.time = DateTime.parse(json["time"]);
  } else {
    assignment.time = null;
  }
  assignment.KU = json.containsKey("KU")
      ? _parseSmallMark(json["KU"])
      : SmallMark.unavailable();
  assignment.T = json.containsKey("T")
      ? _parseSmallMark(json["T"])
      : SmallMark.unavailable();
  assignment.C = json.containsKey("C")
      ? _parseSmallMark(json["C"])
      : SmallMark.unavailable();
  assignment.A = json.containsKey("A")
      ? _parseSmallMark(json["A"])
      : SmallMark.unavailable();
  assignment.O = json.containsKey("O")
      ? _parseSmallMark(json["O"])
      : SmallMark.unavailable();
  assignment.F = json.containsKey("F")
      ? _parseSmallMark(json["F"])
      : SmallMark.unavailable();

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

  weightTable.KU = _parseWeight(json["KU"]);
  weightTable.T = _parseWeight(json["T"]);
  weightTable.C = _parseWeight(json["C"]);
  weightTable.A = _parseWeight(json["A"]);
  weightTable.O = _parseWeight(json["O"]);
  weightTable.F = _parseWeight(json["F"]);

  return weightTable;
}

Course _parseCourse(Map<String, dynamic> json) {
  var course = Course.blank();

  course.startTime = DateTime.parse(json["start_time"]);
  course.endTime = DateTime.parse(json["end_time"]);
  course.name = json["name"];
  course.code = json["code"];
  course.block = json["block"];
  course.room = json["room"];
  course.overallMark = json["overall_mark"];

  if (course.overallMark!=null){
    course.weightTable = _parseWeightTable(json["weight_table"]);
    for (Map<String, dynamic> assignment in json["assignments"]) {
      course.assignments.add(_parseAssignment(assignment));
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
