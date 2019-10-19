import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/res/Strings.dart';

import '../../tools.dart';

class SummaryTab extends StatefulWidget{
  SummaryTab({this.needRefresh});
  final needRefresh;

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab>
    with AfterLayoutMixin<SummaryTab>{
  bool _needRefresh;
  var _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _needRefresh=widget.needRefresh;
  }

  @override
  Widget build(BuildContext context) {
    var courses = getCourseListOf(currentUser.number);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await getAndSaveMarkTimeline(currentUser);
        setState(() {
          courses = getCourseListOf(currentUser.number);
        });
      },
      child: ListView(
        padding: EdgeInsets.only(bottom: 8+getBottomPadding(context)),
        children: _getSummaryCards(courses),
      ),
    );
  }

  List<Widget> _getSummaryCards(List<Course> courses) {
    var list = List<Widget>();

    var total=0.0;
    var availableCourseCount=0;

    courses.forEach((course) {
      if (course.overallMark!=null){
        total+=course.overallMark;
        availableCourseCount++;
      }
      var infoStr = [];
      if (course.block != "") {
        infoStr.add(sprintf(Strings.get("period_number"), [course.block]));
      }
      if (course.room != "") {
        infoStr.add(sprintf(Strings.get("room_number"), [course.room]));
      }
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(course)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(course.displayName,
                      style: Theme.of(context).textTheme.title),
                  SizedBox(height: 4),
                  Text(infoStr.join("  -  "),
                      style: Theme.of(context).textTheme.subhead),
                  SizedBox(height: 16),
                  course.overallMark != null
                      ? LinearPercentIndicator(
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 500,
                    percent: course.overallMark / 100,
                    center: Text(course.overallMark.toString() + "%",
                        style: TextStyle(color: Colors.black)),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Theme.of(context).colorScheme.secondary,
                  )
                      : LinearPercentIndicator(
                    lineHeight: 20.0,
                    percent: 0,
                    center: Text(Strings.get("marks_unavailable"),
                        style: TextStyle(color: Colors.black)),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });

    if (availableCourseCount>0){
      list.insert(0, Divider());

      var avg=total/availableCourseCount;
      list.insert(0, Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.get("average"),
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              getRoundString(avg, 1) + "%",
              style: TextStyle(fontSize: 60),
            ),
            LinearPercentIndicator(
              animation: false,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: avg / 100,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ));
    }

    return list;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if(_needRefresh) {
      _refreshIndicatorKey.currentState.show();
    }
  }
}