import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/detailpage/assignmentstab/MarksList.dart';
import 'package:ta/pages/detailpage/staticstab/StaticsList.dart';
import 'package:ta/pages/detailpage/whatifpage/WhatIfWelcomePage.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/BetterState.dart';

import '../../CustomIcons.dart';
import 'abouttab/AboutTab.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.course);

  final Course course;

  @override
  _DetailPageState createState() => _DetailPageState(course);
}

class _DetailPageState extends BetterState<DetailPage> {
  Course _course;
  var whatIfMode = false;
  var showWhatIfTips = prefs.getBool("show_what_if_tip") ?? true;

  _DetailPageState(this._course);

  updateCourse(course) {
    setState(() {
      _course = course;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_course.displayName, maxLines: 2),
          actions: <Widget>[
            IconButton(
              icon: Icon(whatIfMode ? CustomIcons.lightbulb_filled : Icons.lightbulb_outline),
              onPressed: () async {
                if (showWhatIfTips) {
                  var isEnableWhatIf = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WhatIfWelcomePage()),
                  );
                  if (isEnableWhatIf != true) {
                    return;
                  }
                  showWhatIfTips = false;
                  prefs.setBool("show_what_if_tip", false);
                }
                setState(() {
                  whatIfMode = !whatIfMode;
                  if (!whatIfMode) {
                    var originalCourses = getCourseListOf(currentUser.number);
                    originalCourses.forEach((originalCourse) {
                      if (originalCourse.displayName == _course.displayName) {
                        //course in this detail page
                        _course = originalCourse;
                        return;
                      }
                    });
                  }
                });
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: Strings.get("assignments")),
              Tab(text: Strings.get("statistics")),
              Tab(text: Strings.get("about")),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 0,
              child: AnimatedCrossFade(
                key: Key("add-btn"),
                firstChild: Container(
                  color: Colors.amber,
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            Strings.get("what_if_mode_activated"), style: TextStyle(color: Colors
                            .black)),
                      )),
                ),
                secondChild: Container(),
                crossFadeState: whatIfMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
                firstCurve: Curves.easeInOutCubic,
                secondCurve: Curves.easeInOutCubic,
                sizeCurve: Curves.easeInOutCubic,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MarksList(_course, whatIfMode, updateCourse),
                  StaticsList(_course, whatIfMode),
                  AboutTab(_course),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
