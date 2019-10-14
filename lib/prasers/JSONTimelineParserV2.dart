import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/prasers/JSONCourseListParserV2.dart';

AssignmentAdded _parseAssignmentAdded(Map<String, dynamic> json) {
  var assignmentAdded = AssignmentAdded();
  assignmentAdded.courseName = json["course_name"];
  assignmentAdded.assignmentName = json["assignment_name"];
  assignmentAdded.assignmentAvg = json["assignment_avg"];
  assignmentAdded.overallBefore = json["overall_before"];
  assignmentAdded.overallAfter = json["overall_after"];
  assignmentAdded.time = DateTime.parse(json["time"]);

  return assignmentAdded;
}

AssignmentUpdated _parseAssignmentUpdated(Map<String, dynamic> json) {
  var assignmentUpdated = AssignmentUpdated();
  assignmentUpdated.courseName = json["course_name"];
  assignmentUpdated.assignmentName = json["assignment_name"];
  assignmentUpdated.assignmentBefore = parseAssignment(
      json["assignment_before"]); //remember to change after updated
  assignmentUpdated.assignmentAfter = parseAssignment(json["assignment_after"]);
  assignmentUpdated.time = DateTime.parse(json["time"]);

  return assignmentUpdated;
}

CourseAdded _parseCourseAdded(Map<String, dynamic> json) {
  var courseAdded = CourseAdded();
  courseAdded.courseName = json["course_name"];
  courseAdded.courseBlock = json["course_block"];
  courseAdded.time = DateTime.parse(json["time"]);

  return courseAdded;
}

CourseRemoved _parseCourseRemoved(Map<String, dynamic> json) {
  var courseRemoved = CourseRemoved();
  courseRemoved.courseName = json["course_name"];
  courseRemoved.courseBlock = json["course_block"];
  courseRemoved.time = DateTime.parse(json["time"]);

  return courseRemoved;
}

List<TAUpdate> parseTimeline(List<dynamic> json) {
  var updates = List<TAUpdate>();

  json.forEach((update) {
    switch (update["category"]) {
      case "assignment_added":
        updates.add(_parseAssignmentAdded(update));
        break;
      case "assignment_updated":
        updates.add(_parseAssignmentUpdated(update));
        break;
      case "course_added":
        updates.add(_parseCourseAdded(update));
        break;
      case "course_removed":
        updates.add(_parseCourseRemoved(update));
    }
  });

  return updates;
}
