import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChartDetail.dart';
import 'package:ta/res/Strings.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Course course;

  EditAssignmentDialog(this.course);

  @override
  _EditAssignmentDialogState createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends State<EditAssignmentDialog> {
  Assignment assignment;
  var isAdvanced = false;
  var _titleController = TextEditingController();

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
          null);
      _titleController.text = assignment.name;
    }

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
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
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
                          firstChild: _SimpleEdit(),
                          secondChild: _AdvancedEdit(),
                          crossFadeState:
                              isAdvanced ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                          firstCurve: Curves.easeInOutCubic,
                          secondCurve: Curves.easeInOutCubic,
                          sizeCurve: Curves.easeInOutCubic,
                        ),
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
                        color: Theme.of(context).colorScheme.secondary,
                        child: Text("Add"),
                        onPressed: () {
                          Navigator.pop(context);
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
    smallMark.total = 10;
    smallMark.get = 9;
    smallMark.weight = 10;
    return smallMark;
  }
}

class _SimpleEdit extends StatefulWidget {
  @override
  __SimpleEditState createState() => __SimpleEditState();
}

class __SimpleEditState extends State<_SimpleEdit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
              sliderTheme: SliderThemeData(
                  activeTrackColor: Theme.of(context).colorScheme.secondary,
                  inactiveTrackColor: Theme.of(context).colorScheme.secondary,
                  thumbColor: Theme.of(context).colorScheme.primary)),
          child: Slider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: (v) {},
          ),
        )
      ],
    );
  }
}

class _AdvancedEdit extends StatefulWidget {
  @override
  __AdvancedEditState createState() => __AdvancedEditState();
}

class __AdvancedEditState extends State<_AdvancedEdit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: Strings.get("ku")),
            Tab(text: Strings.get("t")),
            Tab(text: Strings.get("c")),
            Tab(text: Strings.get("a")),
            Tab(text: Strings.get("o")),
          ],
        ),
        SizedBox(
          height: 200,
          child: TabBarView(
            children: <Widget>[
              EditSmallMark(
                category: "a",
              ),
              EditSmallMark(
                category: "a",
              ),
              EditSmallMark(
                category: "a",
              ),
              EditSmallMark(
                category: "a",
              ),
              EditSmallMark(
                category: "a",
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EditSmallMark extends StatefulWidget {
  final Key key;
  final String category;

  EditSmallMark({this.key, this.category});

  @override
  _EditSmallMarkState createState() => _EditSmallMarkState();
}

class _EditSmallMarkState extends State<EditSmallMark> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 200,
    );
  }
}
