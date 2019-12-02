import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/pages/summarypage/CourseCard.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;

import '../../tools.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab({this.courses, this.onRefresh, this.needRefresh});

  final List<Course> courses;
  final bool needRefresh;
  final RefreshCallback onRefresh;

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab>
    with AfterLayoutMixin<SummaryTab>, AutomaticKeepAliveClientMixin {
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var sidePadding = (widthOf(context) - 500) / 2;
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: widget.onRefresh,
      child: ListView(
        padding: EdgeInsets.only(
            bottom: 8 + getBottomPadding(context),
            left: sidePadding > 0 ? sidePadding : 0,
            right: sidePadding > 0 ? sidePadding : 0),
        children: _getSummaryCards(widget.courses),
      ),
    );
  }

  List<Widget> _getSummaryCards(List<Course> courses) {
    var list = List<Widget>();

    var total = 0.0;
    var availableCourseCount = 0;

    courses.forEach((course) {
      if (course.overallMark != null) {
        total += course.overallMark;
        availableCourseCount++;
      }

      list.add(CourseCard(
        course: course,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(course)),
          );
        },
      ));
    });

    if (availableCourseCount > 0) {
      list.insert(0, Divider());

      var avg = total / availableCourseCount;
      list.insert(
          0,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  Strings.get("average"),
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  num2Str(avg) + "%",
                  style: TextStyle(fontSize: 60),
                ),
                LPI.LinearProgressIndicator(
                  animationDuration: 700,
                  lineHeight: 20.0,
                  value1: avg / 100,
                  value1Color: primaryColorOf(context),
                ),
              ],
            ),
          ));
    }

    return list;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.needRefresh) {
      _refreshIndicatorKey.currentState.show();
    }
  }
}
