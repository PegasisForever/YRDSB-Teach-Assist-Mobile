import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChartDetail.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/InputDoneView.dart';

import 'AssignmentAdvancedEdit.dart';
import 'AssignmentSimpleEdit.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Course course;
  final Assignment assignment;

  EditAssignmentDialog({this.course, this.assignment});

  @override
  _EditAssignmentDialogState createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends State<EditAssignmentDialog>
    with AfterLayoutMixin<EditAssignmentDialog> {
  Assignment assignment;
  var isAdvanced = false;
  var _titleController = TextEditingController();
  bool isAdd;
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    assignment = widget.assignment?.copy();
    isAdd = assignment == null;
    if (assignment == null) {
      assignment = Assignment(
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          getTemplateSmallMark(),
          SmallMark.unavailable(),
          SmallMark.unavailable(),
          Strings.get("untitled_assignment"),
          null)
        ..added = true;
    }

    assignment.edited = true;
    _titleController.text = assignment.name;
  }

  @override
  Widget build(BuildContext context) {
    var course = widget.course;
    var avg = assignment.getAverage(course.weightTable);

    return SingleChildScrollView(
      child: Dialog(
        child: DefaultTabController(
          length: 6,
          initialIndex: 0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      assignment.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .title,
                    ),
                    SizedBox(height: 4),
                    Text(Strings.get("average:") + ((avg != null) ? (num2Str(avg) + "%") : "N/A"),
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 8),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: SmallMarkChartDetail(
                          assignment,
                          height: 170,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration:
                      InputDecoration(labelText: Strings.get("assignment_title"), filled: true),
                      onChanged: (text) {
                        setState(() {
                          assignment.name = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: Text(Strings.get("advanced_mode")),
                        value: isAdvanced,
                        onChanged: (value) {
                          setState(() {
                            isAdvanced = value;
                          });
                        },
                      ),
                      CrossFade(
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
                        showFirst: !isAdvanced,
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(Strings.get("cancel").toUpperCase()),
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
                      isAdd ? Strings.get("add").toUpperCase() : Strings.get("save").toUpperCase(),
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

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!isAndroid()) {
      KeyboardVisibilityNotification().addNewListener(onShow: () {
        showOverlay(context);
      }, onHide: () {
        removeOverlay();
      });
    }
  }
}
