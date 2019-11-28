import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/pages/summarypage/CourseCard.dart';
import 'package:ta/res/Strings.dart';

import 'AwardBar.dart';

class ArchivedCoursesPage extends StatefulWidget {
  @override
  _ArchivedCoursesPageState createState() => _ArchivedCoursesPageState();
}

class _ArchivedCoursesPageState extends State<ArchivedCoursesPage>
    with AfterLayoutMixin<ArchivedCoursesPage> {
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var archivedCourses = getArchivedCourseListOf(currentUser.number);

  @override
  Widget build(BuildContext context) {
    var bronze = 0;
    var silver = 0;
    var gold = 0;
    archivedCourses.forEach((course) {
      if (course.overallMark >= 99) {
        gold++;
      } else if (course.overallMark >= 90) {
        silver++;
      } else if (course.overallMark >= 80) {
        bronze++;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("archived_marks")),
      ),
      body: Stack(
        children: <Widget>[
          if (archivedCourses.length == 0)
            Center(
              child: Text(
                Strings.get(
                  "no_archived_courses",
                ),
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead,
              ),
            ),
          RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              try {
                await getAndSaveArchived(currentUser);
                setState(() {
                  archivedCourses = getArchivedCourseListOf(currentUser.number);
                });
              } catch (e) {}
            },
            child: ListView.builder(
              itemCount: archivedCourses.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return AwardBar(bronze, silver, gold);
                } else {
                  var course = archivedCourses[index - 1];
                  return CourseCard(
                    course: course,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage(course)),
                      );
                    },
                    showIcons: false,
                    showAnimations: false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _refreshIndicatorKey.currentState.show();
  }
}
