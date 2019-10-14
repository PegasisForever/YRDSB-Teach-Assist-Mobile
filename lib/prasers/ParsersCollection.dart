import 'package:ta/prasers/JSONCourseListParserV1.dart' as CourseListParserV1;
import 'package:ta/prasers/JSONCourseListParserV2.dart' as CourseListParserV2;

import 'JSONTimelineParserV2.dart';

var JSONCourseListParsers={
  1:CourseListParserV1.parseJSONCourseList,
  2:CourseListParserV2.parseJSONCourseList
};

var JSONTimelineParsers={
  2:parseTimeline
};