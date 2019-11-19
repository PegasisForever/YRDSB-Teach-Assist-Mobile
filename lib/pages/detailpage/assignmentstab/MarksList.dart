import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/whatifpage/EditAssignmentDialog.dart';
import 'package:ta/res/Strings.dart';

import 'MarksListTile.dart';

class MarksList extends StatefulWidget {
  MarksList(this._course, this._whatIfMode);

  final Course _course;
  final bool _whatIfMode;

  @override
  _MarksListState createState() => _MarksListState();
}

class _MarksListState extends State<MarksList> with TickerProviderStateMixin {
  var showTips = prefs.getBool("show_tap_to_view_detail_tip") ?? true;

  @override
  Widget build(BuildContext context) {
    var course = widget._course;
    var whatIfMode = widget._whatIfMode;

    return course.overallMark != null
        ? AnimatedList(
      initialItemCount: course.assignments.length + 1,
      itemBuilder: (context, index, animation) {
              if (index == 0) {
                return AnimatedCrossFade(
                  key: Key("add-btn"),
                  firstChild: Center(
                    child: FlatButton.icon(
                        onPressed: () {
                          ShowAddAssignment(context, course);
                        },
                        icon: Icon(Icons.add),
                        label: Text("New Assignment")),
                  ),
                  secondChild: Container(
                    height: 1,
                  ),
                  crossFadeState: whatIfMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                  firstCurve: Curves.easeInOutCubic,
                  secondCurve: Curves.easeInOutCubic,
                  sizeCurve: Curves.easeInOutCubic,
                );
              }

              var assiIndex = course.assignments.length - index;
              var assi = course.assignments[assiIndex];
              return SizeTransition(
                key: Key(assi.hashCode.toString()),
                axis: Axis.horizontal,
                sizeFactor: animation,
                child: Column(
                  children: <Widget>[MarksListTile(assi, course.weightTable)],
                ),
              );
            },
          )
        : Center(
            child: Text(
              Strings.get("assignments_unavailable"),
              style: Theme.of(context).textTheme.subhead,
            ),
          );
  }

  ShowAddAssignment(BuildContext context, Course course) {
    showDialog(context: context, builder: (context) {
      return EditAssignmentDialog(course);
    });
  }
}
