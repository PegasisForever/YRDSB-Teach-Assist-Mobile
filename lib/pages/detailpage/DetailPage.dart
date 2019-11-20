import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/MarksList.dart';
import 'package:ta/pages/detailpage/staticstab/StaticsList.dart';
import 'package:ta/pages/detailpage/whatifpage/EditAssignmentDialog.dart';
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
              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => WhatIfPage()),
//                );
                setState(() {
                  whatIfMode = !whatIfMode;
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
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Text("What If Mode Activated", style: TextStyle(color: Colors.black)),
                      ),
                      FlatButton.icon(
                          onPressed: () async {
                            var newAssi = await showAddAssignment(context, _course);
                            if (newAssi != null) {
                              setState(() {
                                _course.assignments.add(newAssi);
                              });
                            }
                          },
                          icon: Icon(Icons.add),
                          label: Text("New Assignment")),
                    ],
                  ),
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
                  StaticsList(_course),
                  AboutTab(_course),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Assignment> showAddAssignment(BuildContext context, Course course,
      {Assignment assignment}) async {
    return await showDialog<Assignment>(
        context: context,
        builder: (context) {
          return EditAssignmentDialog(course: course, assignment: assignment);
        });
  }
}
