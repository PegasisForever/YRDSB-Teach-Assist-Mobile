import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/prasers/JSONCourseListParserV4.dart' as CourseListParserV4;
import 'package:ta/prasers/JSONCourseListParserV8.dart' as CourseListParserV8;
import 'package:ta/prasers/JSONTimelineParserV4.dart' as TimelineParserV4;
import 'package:ta/prasers/JSONTimelineParserV6.dart' as TimelineParserV6;
import 'package:ta/prasers/JSONTimelineParserV9.dart' as TimelineParserV9;

const _JSONCourseListParsers = {
  4: CourseListParserV4.parseJSONCourseList,
  5: CourseListParserV4.parseJSONCourseList,
  6: CourseListParserV4.parseJSONCourseList,
  7: CourseListParserV4.parseJSONCourseList,
  8: CourseListParserV8.parseJSONCourseList,
  9: CourseListParserV8.parseJSONCourseList,
};

List<Course> parseCourseList(Map<String,dynamic> json) {
  try {
    if(json.length==0){
      return List<Course>();
    }
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
  6: TimelineParserV6.parseTimeline,
  7: TimelineParserV6.parseTimeline,
  8: TimelineParserV6.parseTimeline,
  9: TimelineParserV9.parseTimeline,
};

List<TAUpdate> parseTimeLine(Map<String,dynamic> json) {
  try {
    var version = json["version"];
    var data = json["data"];
    return _jsonTimelineParsers[version](data);
  } catch (e, trace) {
    print(trace);
    return List<TAUpdate>();
  }
}
