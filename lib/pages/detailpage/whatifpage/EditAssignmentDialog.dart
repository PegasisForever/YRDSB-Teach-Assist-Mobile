import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChartDetail.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

import 'AssignmentAdvancedEdit.dart';
import 'AssignmentSimpleEdit.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Course course;
  final Assignment assignment;

  EditAssignmentDialog({this.course, this.assignment});

  @override
  _EditAssignmentDialogState createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends State<EditAssignmentDialog> {
  Assignment assignment;
  var isAdvanced = false;
  var _titleController = TextEditingController();
  bool isAdd;

  @override
  void initState() {
    super.initState();
    assignment = widget.assignment?.copy();
    isAdd = assignment == null;
  }

  @override
  Widget build(BuildContext context) {
    var course = widget.course;
    if (assignment == null) {
      assignment = Assignment(
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          SmallMark.unavailable(),
          SmallMark.unavailable(),
          "Untitled Assignment",
          null)
        ..added = true;
    }

    assignment.edited = true;
    _titleController.text = assignment.name;

    var avg = assignment.getAverage(course.weightTable);

    return Dialog(
      child: DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      assignment.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                        Strings.get("average:") +
                            ((avg != null) ? (getRoundString(avg, 1) + "%") : "N/A"),
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(
                      height: 4,
                    ),
                    SmallMarkChartDetail(
                      assignment,
                      height: 170,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Assignment Title", filled: true),
                      onChanged: (text) {
                        setState(() {
                          assignment.name = text;
                        });
                      },
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title: Text("Advanced Mode"),
                          value: isAdvanced,
                          onChanged: (value) {
                            setState(() {
                              isAdvanced = value;
                            });
                          },
                        ),
                        AnimatedCrossFade(
                          firstChild: SimpleEdit(
                            weights: course.weightTable,
                            assignment: assignment,
                            onChanged: (assi) {
                              setState(() {
                                assignment = assi;
                              });
                            },
                          ),
                          secondChild: AdvancedEdit(
                              assignment: assignment,
                              onChanged: (assi) {
                                setState(() {
                                  assignment = assi;
                                });
                              }),
                          crossFadeState:
                              isAdvanced ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                          firstCurve: Curves.easeInOutCubic,
                          secondCurve: Curves.easeInOutCubic,
                          sizeCurve: Curves.easeInOutCubic,
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        child: Text(
                          isAdd ? "Add" : "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(assignment);
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SmallMark getTemplateSmallMark() {
    var smallMark = SmallMark.blank();
    smallMark.finished = true;
    smallMark.available = true;
    smallMark.total = 100;
    smallMark.get = 90;
    smallMark.weight = 10;
    return smallMark;
  }
}
