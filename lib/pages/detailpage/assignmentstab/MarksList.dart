import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/MarksListTile.dart';
import 'package:ta/pages/detailpage/whatifpage/EditAssignmentDialog.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterAnimatedList.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/TipsCard.dart';

class MarksList extends StatefulWidget {
  MarksList({this.course, this.whatIfMode, this.updateCourse});

  final Function updateCourse;
  final Course course;
  final bool whatIfMode;

  @override
  MarksListState createState() => MarksListState();
}

class MarksListState extends State<MarksList>
    with AutomaticKeepAliveClientMixin {
  var showTips = prefs.getBool("show_tap_to_view_detail_tip") ?? true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var whatIfMode = widget.whatIfMode;
    var course = widget.course;
    var sidePadding = (widthOf(context) - 500) / 2;
    return Stack(
      children: <Widget>[
        if (course.overallMark == null || course.assignments.length == 0)
          Center(
            child: Text(
              Strings.get("assignments_unavailable"),
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
        if (course.assignments != null)
          BetterAnimatedList(
            padding: EdgeInsets.only(
              top: 56,
              left: sidePadding > 0 ? sidePadding : 0,
              right: sidePadding > 0 ? sidePadding : 0,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            list: course.assignments.reversed.toList(),
            header: Column(
              children: <Widget>[
                CrossFade(
                    key: Key("tip"),
                    firstChild: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TipsCard(
                        padding: const EdgeInsets.only(left: 8, right: 6),
                        text: Strings.get("tap_to_view_detail"),
                        leading: Icon(Icons.info_outline),
                        trailing: FlatButton(
                          child: Text(Strings.get("dismiss")),
                          onPressed: () {
                            setState(() {
                              showTips = false;
                              prefs.setBool("show_tap_to_view_detail_tip", false);
                            });
                          },
                        ),
                      ),
                    ),
                    secondChild: SizedBox(
                      height: 0.5,
                      width: double.infinity,
                    ),
                    showFirst: showTips),
                CrossFade(
                    key: Key("add-btn"),
                    firstChild: Column(
                      children: <Widget>[
                        Center(
                          child: FlatButton.icon(
                              onPressed: () => addAssignment(context),
                              icon: Icon(Icons.add),
                              label: Text(Strings.get("new_assignment"))),
                        ),
                        Divider()
                      ],
                    ),
                    secondChild: SizedBox(
                      height: 0.5,
                      width: double.infinity,
                    ),
                    showFirst: whatIfMode)
              ],
            ),
            itemBuilder: (context, assignment) {
              return MarksListTile(
                assignment,
                course.weightTable,
                whatIfMode,
                editAssignment: editAssignment,
                removeAssignment: removeAssignment,
              );
            },
          )
      ],
    );
  }

  removeAssignment(Assignment assignment) async {
    await showDialog<Assignment>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(sprintf(Strings.get("remove_assignment"), [assignment.displayName])),
            content: assignment.added != true ? Text(Strings.get("it_will_be_restored")) : null,
            actions: <Widget>[
              FlatButton(
                child: Text(Strings.get("cancel").toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(Strings.get("remove").toUpperCase()),
                onPressed: () {
                  widget.course.assignments.remove(assignment);
                  widget.updateCourse(widget.course);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  editAssignment(BuildContext context, Assignment assignment) async {
    var index = widget.course.assignments.indexOf(assignment);
    var newAssignment = await showDialog<Assignment>(
        context: context,
        builder: (context) {
          return EditAssignmentDialog(
            course: widget.course,
            assignment: assignment,
          );
        });
    if (newAssignment != null) {
      widget.course.assignments.removeAt(index);
      widget.course.assignments.insert(index, newAssignment);
      widget.updateCourse(widget.course);
    }
  }

  addAssignment(BuildContext context) async {
    var newAssignment = await showDialog<Assignment>(
        context: context,
        builder: (context) {
          return EditAssignmentDialog(course: widget.course);
        });
    if (newAssignment != null) {
      widget.course.assignments.add(newAssignment);
      widget.updateCourse(widget.course);
    }
  }
}
