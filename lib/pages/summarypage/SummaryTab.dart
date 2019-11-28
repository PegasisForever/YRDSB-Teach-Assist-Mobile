import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/pages/summarypage/CourseCard.dart';
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
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var courses = getCourseListOf(currentUser.number);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

      list.add(CourseCard(
        course: course,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(course)),
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
