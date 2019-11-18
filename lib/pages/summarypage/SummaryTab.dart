import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;

import '../../tools.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab({this.needRefresh});

  final needRefresh;

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab>
    with AfterLayoutMixin<SummaryTab>, AutomaticKeepAliveClientMixin {
  var _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var courses = getCourseListOf(currentUser.number);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        try {
          await getAndSaveMarkTimeline(currentUser);
          setState(() {
            courses = getCourseListOf(currentUser.number);
          });
        } catch (e) {
          _handleError(e);
        }
      },
      child: ListView(
        padding: EdgeInsets.only(bottom: 8 + getBottomPadding(context)),
        children: _getSummaryCards(courses),
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
      var infoStr = [];
      if (course.block != null) {
        infoStr.add(sprintf(Strings.get("period_number"), [course.block]));
      }
      if (course.room != null) {
        infoStr.add(sprintf(Strings.get("room_number"), [course.room]));
      }
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
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
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 4,
                      runSpacing: 4,
                      children: <Widget>[
                        Text(course.displayName, style: Theme.of(context).textTheme.title),
                        if (course.cached)
                          Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text(
                              Strings.get("cached"),
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                      ]),
                  SizedBox(height: 4),
                  if (infoStr.length > 0)
                    Text(infoStr.join("  -  "), style: Theme.of(context).textTheme.subhead),
                  SizedBox(height: 16),
                  course.overallMark != null
                      ? LPI.LinearProgressIndicator(
                          lineHeight: 20.0,
                          animationDuration: 700,
                          value1: course.overallMark / 100,
                          center: Text(course.overallMark.toString() + "%",
                              style: TextStyle(color: Colors.black)),
                          value1Color: Theme.of(context).colorScheme.secondary,
                        )
                      : LPI.LinearProgressIndicator(
                          lineHeight: 20.0,
                          value1: 0,
                          center: Text(Strings.get("marks_unavailable"),
                              style: TextStyle(color: Colors.black)),
                        ),
                ],
              ),
            ),
          ),
        ),
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
                  getRoundString(avg, 1) + "%",
                  style: TextStyle(fontSize: 60),
                ),
                LPI.LinearProgressIndicator(
                  animationDuration: 700,
                  lineHeight: 20.0,
                  value1: avg / 100,
                  value1Color: Theme.of(context).colorScheme.primary,
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

  void _handleError(e) {
    if (e.message == "426") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Strings.get("version_no_longer_supported")),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.get("ok").toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    } else if (e.message == "401") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Strings.get("ur_ta_pwd_has_changed")),
              content: Text(Strings.get("u_need_to_update_your_password")),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.get("cancel").toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text(Strings.get("update_password").toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditAccount(currentUser, true)),
                      );
                    }),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    }
  }
}
