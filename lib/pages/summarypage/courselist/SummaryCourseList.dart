import 'package:flutter/material.dart'
    hide LinearProgressIndicator, ExpansionTile;
import 'package:ta/model/HiddenCourse.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/courselist/AllCourseAverage.dart';
import 'package:ta/pages/summarypage/courselist/HidableCourseCard.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/ExpansionTile.dart';

class SummaryCourseList extends StatefulWidget {
  @override
  _SummaryCourseListState createState() => _SummaryCourseListState();
}

class _SummaryCourseListState extends State<SummaryCourseList> {
  @override
  Widget build(BuildContext context) {
    List<Course> courses = getCourseListOf(currentUser.number);
    var list = List<Widget>();

    var total = 0.0;
    var availableCourseCount = 0;
    var hiddenCourseList = HiddenCourse.getAll();
    var hiddenCourseCount = 0;

    courses.forEach((course) {
      if (course.overallMark != null && course.overallMark != 0) {
        total += course.overallMark;
        availableCourseCount++;
      }
      var isShow = !HiddenCourse.isInList(hiddenCourseList, course);
      if (!isShow) hiddenCourseCount++;

      list.add(HidableCourseCard(
        course: course,
        isShow: isShow,
        menuText: Strings.get("hide_this_course"),
        onMenuTap: () => setState(() {
          HiddenCourse.add(course);
        }),
      ));
    });

    if (availableCourseCount > 0) {
      var avg = total / availableCourseCount;
      list.insert(0, AllCourseAverage(avg));
    }

    var hiddenCourseCards = <Widget>[];
    courses.forEach((course) {
      hiddenCourseCards.add(HidableCourseCard(
        course: course,
        isShow: HiddenCourse.isInList(hiddenCourseList, course),
        menuText: Strings.get("restore_this_course"),
        onMenuTap: () => setState(() {
          HiddenCourse.remove(course);
        }),
      ));
    });

    list.add(ExpansionTile(
      title: Text(Strings.get("hidden_courses")),
      children: hiddenCourseCards,
      shouldShowTile: hiddenCourseCount > 0,
    ));

    return Column(
      children: list,
    );
  }
}
