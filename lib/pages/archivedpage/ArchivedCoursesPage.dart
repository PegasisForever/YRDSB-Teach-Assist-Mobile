import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/archivedpage/AwardBar.dart';
import 'package:ta/pages/summarypage/CourseCard.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class ArchivedCoursesPage extends StatefulWidget {
  @override
  _ArchivedCoursesPageState createState() => _ArchivedCoursesPageState();
}

class _ArchivedCoursesPageState extends State<ArchivedCoursesPage>
    with AfterLayoutMixin<ArchivedCoursesPage> {
  var _noDataRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _haveDataRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var archivedCourses = getArchivedCourseListOf(currentUser.number);

  @override
  Widget build(BuildContext context) {
    var sidePadding = (widthOf(context) - 500) / 2;
    return archivedCourses.length == 0
        ? _noDataView(
            sidePadding: sidePadding,
          )
        : _haveDataView(
            sidePadding: sidePadding,
          );
  }

  Widget _haveDataView({double sidePadding}) {
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            title: Text(Strings.get("archived_marks")),
            forceElevated: true,
            floating: false,
            snap: false,
          ),
        ],
        body: RefreshIndicator(
          key: _haveDataRefreshIndicatorKey,
          onRefresh: () async {
            try {
              await getAndSaveArchived(currentUser);
              setState(() {
                archivedCourses = getArchivedCourseListOf(currentUser.number);
              });
            } catch (e) {}
          },
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: max(sidePadding, 6),
              right: max(sidePadding, 6),
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            itemCount: archivedCourses.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return AwardBar(bronze, silver, gold);
              } else {
                var course = archivedCourses[index - 1];
                return CourseCard(
                  course: course,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: [course],
                    );
                  },
                  showIcons: false,
                  showAnimations: false,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _noDataView({double sidePadding}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("archived_marks")),
      ),
      body: RefreshIndicator(
        key: _noDataRefreshIndicatorKey,
        onRefresh: () async {
          try {
            await getAndSaveArchived(currentUser);
            setState(() {
              archivedCourses = getArchivedCourseListOf(currentUser.number);
            });
          } catch (e) {}
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: max(sidePadding, 6),
                      right: max(sidePadding, 6),
                    ),
                    child: AwardBar(0, 0, 0),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      Strings.get(
                        "no_archived_courses",
                      ),
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _noDataRefreshIndicatorKey.currentState?.show();
    _haveDataRefreshIndicatorKey.currentState?.show();
  }
}
