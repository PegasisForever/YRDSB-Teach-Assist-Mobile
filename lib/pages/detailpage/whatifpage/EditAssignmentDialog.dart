import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/whatifpage/SmallMarkEditor.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/InputDoneView.dart';
import 'package:ta/widgets/NoBackgroundDialog.dart';
import 'package:ta/widgets/SmallIconButton.dart';
import 'package:ta/widgets/TipsCard.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Course course;
  final Assignment assignment;

  EditAssignmentDialog({this.course, this.assignment});

  @override
  _EditAssignmentDialogState createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends BetterState<EditAssignmentDialog> with AfterLayoutMixin<EditAssignmentDialog> {
  Assignment assignment;
  var isAdvanced = false;
  var _titleController = TextEditingController();
  bool isAdd;
  OverlayEntry overlayEntry;
  var showTips = prefs.getBool("show_assi_edit_tip_2") ?? true;

  @override
  void initState() {
    super.initState();
    assignment = widget.assignment?.copy();
    isAdd = assignment == null;
    if (assignment == null) {
      assignment = Assignment({
        Category.KU: getTemplateSmallMarkGroup(),
        Category.T: getTemplateSmallMarkGroup(),
        Category.C: getTemplateSmallMarkGroup(),
        Category.A: getTemplateSmallMarkGroup(),
        Category.O: SmallMarkGroup.blank(),
        Category.F: SmallMarkGroup.blank()
      }, Strings.get("untitled_assignment"), null)
        ..added = true;
    }

    assignment.edited = true;
    _titleController.text = assignment.name;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!isAndroid()) {
      var keyboardVisibilityController = KeyboardVisibilityController();
      keyboardVisibilityController.onChange.listen((bool visible) {
        if (visible) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var course = widget.course;
    var avg = assignment.getAverage(course.weightTable);

    var smallMarkEditors = <SmallMarkEditor>[];
    for (final category in Category.values) {
      var smallMarkGroup = assignment[category];
      if (smallMarkGroup.smallMarks.length > 0) {
        for (int i = 0; i < smallMarkGroup.smallMarks.length; i++) {
          smallMarkEditors.add(SmallMarkEditor(
            smallMark: smallMarkGroup.smallMarks[i],
            category: category,
            key: Key(category.toString() + i.toString()),
            onChanged: (smallMark) {
              setState(() {
                smallMarkGroup.smallMarks[i] = smallMark;
              });
            },
          ));
        }
      } else {
        smallMarkEditors.add(SmallMarkEditor(
          smallMark: null,
          category: category,
          key: Key(category.toString() + "0"),
          onChanged: (smallMark) {
            setState(() {
              if (smallMarkGroup.available) {
                if (smallMark != null) {
                  smallMarkGroup.smallMarks[0] = smallMark;
                } else {
                  smallMarkGroup.smallMarks.removeAt(0);
                }
              } else if (smallMark != null) {
                smallMarkGroup.smallMarks.add(smallMark);
              }
            });
          },
        ));
      }
    }

    return NoBackgroundDialog(
      maxWidth: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CrossFade(
            firstChild: TipsCard(
              text: Strings.get("assi_edit_tip"),
              padding: const EdgeInsets.all(8),
              trailing: SmallIconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    showTips = false;
                    prefs.setBool("show_assi_edit_tip_2", false);
                  });
                },
              ),
            ),
            secondChild: Container(),
            showFirst: showTips,
          ),
          AnimatedContainer(
            height: showTips ? 10 : 0,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 300),
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        keyboardAppearance: isLightMode(context: context) ? Brightness.light : Brightness.dark,
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: Strings.get("assignment_title"),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                        style: TextStyle(fontSize: 17),
                        onChanged: (text) {
                          setState(() {
                            assignment.name = text;
                          });
                        },
                      ),
                      SizedBox(height: 4),
                      Text(Strings.get("average:") + ((avg != null) ? (num2Str(avg) + "%") : "N/A"),
                          style: TextStyle(fontSize: 16, color: getGrey(100, context: context))),
                      SizedBox(height: 8),
                      Center(
                        child: SizedBox(
                          height: 180,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: smallMarkEditors,
                          ),
                        ),
                      ),
                    ],
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
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(
                        isAdd ? Strings.get("add").toUpperCase() : Strings.get("save").toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        assignment.smallMarkGroups.forEach((_, smallMarkGroup) {
                          smallMarkGroup.smallMarks
                              .removeWhere((smallMark) => smallMark == null || smallMark.enabled == false);
                        });
                        Navigator.of(context).pop(assignment);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          AnimatedContainer(
            height: showTips ? 40 : 0,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  SmallMarkGroup getTemplateSmallMarkGroup() {
    var smallMark = SmallMark.blank();
    smallMark.finished = true;
    smallMark.total = 100;
    smallMark.get = 90;
    smallMark.weight = 10;
    return SmallMarkGroup.blank()..smallMarks.add(smallMark);
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: getBottomPadding(context),
        right: 0.0,
        left: 0.0,
        child: InputDoneView(),
      );
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
