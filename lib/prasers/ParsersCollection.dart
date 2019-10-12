import 'package:ta/prasers/JSONCourseListParserV1.dart' as CourseListParserV1;
import 'package:ta/prasers/JSONCourseListParserV2.dart' as CourseListParserV2;

var JSONCourseListParsers={
  1:CourseListParserV1.parseJSONCourseList,
  2:CourseListParserV2.parseJSONCourseList
};