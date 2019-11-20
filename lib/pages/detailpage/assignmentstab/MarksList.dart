import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/whatifpage/EditAssignmentDialog.dart';

import 'MarksListTile.dart';

class MarksList extends StatefulWidget {
  MarksList(this._course, this._whatIfMode, this._updateCourse);

  final Function _updateCourse;
  final Course _course;
  final bool _whatIfMode;

  @override
  _MarksListState createState() => _MarksListState();
}

class _MarksListState extends State<MarksList> with TickerProviderStateMixin {
  var showTips = prefs.getBool("show_tap_to_view_detail_tip") ?? true;

  @override
  Widget build(BuildContext context) {
    var whatIfMode = widget._whatIfMode;
    var course = widget._course;
    return AnimatedList(
      initialItemCount: course.assignments.length + 1,
      itemBuilder: (context, index, animation) {
        if (index == 0) {
          return AnimatedCrossFade(
            key: Key("add-btn"),
            firstChild: Center(
              child: FlatButton.icon(
                  onPressed: () async {
                    var newAssi = await showAddAssignment(context, course);
                    if (newAssi != null) {
                      course.assignments.add(newAssi);
                      widget._updateCourse(course);
                      AnimatedList.of(context).insertItem(1);
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("New Assignment")),
            ),
            secondChild: SizedBox(
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
            axis: Axis.vertical,
            sizeFactor: animation,
            child: MarksListTile(
              assi,
              course.weightTable,
            ));
      },
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
