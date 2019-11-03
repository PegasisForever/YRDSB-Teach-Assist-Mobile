import 'package:ta/prasers/JSONCourseListParserV1.dart' as CourseListParserV1;
import 'package:ta/prasers/JSONCourseListParserV2.dart' as CourseListParserV2;
import 'package:ta/prasers/JSONCourseListParserV3.dart' as CourseListParserV3;
import 'package:ta/prasers/JSONTimelineParserV2.dart' as TimelineParserV2;
import 'package:ta/prasers/JSONTimelineParserV3.dart' as TimelineParserV3;

import 'JSONTimelineParserV2.dart';

var JSONCourseListParsers={
  1:CourseListParserV1.parseJSONCourseList,
  2:CourseListParserV2.parseJSONCourseList,
  3:CourseListParserV3.parseJSONCourseList
};

var JSONTimelineParsers={
  2:TimelineParserV2.parseTimeline,
  3:TimelineParserV3.parseTimeline
};