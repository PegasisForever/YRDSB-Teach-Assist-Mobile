import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/TipsCard.dart';
import 'package:ta/res/Strings.dart';

import 'MarksListTile.dart';

class MarksList extends StatefulWidget {
  MarksList(this._course);

  final Course _course;

  @override
  _MarksListState createState() => _MarksListState(_course);
}

class _MarksListState extends State<MarksList> with TickerProviderStateMixin {
  final Course _course;
  var showTips = prefs.getBool("show_tap_to_view_detail_tip") ?? true;

  _MarksListState(this._course);

  @override
  Widget build(BuildContext context) {
    return _course.overallMark != null
        ? ListView.builder(
            cacheExtent: double.maxFinite,
            itemCount: _course.assignments.length * 2 + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return AnimatedSize(
                  vsync: this,
                  curve: Curves.easeInOutCubic,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedSwitcher(
                      child: showTips
                          ? TipsCard(
                              text: Strings.get("tap_to_view_detail"),
                              onDismiss: () {
                                setState(() {
                                  showTips = false;
                                  prefs.setBool("show_tap_to_view_detail_tip", false);
                                });
                              })
                          : SizedBox(
                              height: 8,
                            ),
                      duration: Duration(milliseconds: 300)),
                );
              }
              if (index.isOdd) {
                var assignment =
                    _course.assignments[_course.assignments.length - 1 - ((index - 1) ~/ 2)];
                return MarksListTile(assignment, _course.weightTable);
              } else {
                return Divider();
              }
            },
          )
        : Center(
            child: Text(
              Strings.get("assignments_unavailable"),
              style: Theme.of(context).textTheme.subhead,
            ),
          );
  }
}
