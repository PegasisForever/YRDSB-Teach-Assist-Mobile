import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/prasers/JSONCourseListParserV4.dart' as CourseListParserV4;
import 'package:ta/prasers/JSONTimelineParserV4.dart' as TimelineParserV4;

const _JSONCourseListParsers = {
  4: CourseListParserV4.parseJSONCourseList,
  5: CourseListParserV4.parseJSONCourseList,
};

List<Course> parseCourseList(dynamic json) {
  try {
    var version = json["version"];
    var data = json["data"];
    return _JSONCourseListParsers[version](data);
  } catch (e, trace) {
    print(trace);
    return List<Course>();
  }
}

const _jsonTimelineParsers = {
  4: TimelineParserV4.parseTimeline,
  5: TimelineParserV4.parseTimeline,
};

List<TAUpdate> parseTimeLine(dynamic json) {
  try {
    var version = json["version"];
    var data = json["data"];
    return _jsonTimelineParsers[version](data);
  } catch (e, trace) {
    print(trace);
    return List<TAUpdate>();
  }
}
