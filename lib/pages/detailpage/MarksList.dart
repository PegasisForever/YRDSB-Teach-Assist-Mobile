import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/SmallMarkChartDetail.dart';
import 'package:ta/res/Strings.dart';

import 'SmallMarkChart.dart';

class MarksList extends StatefulWidget {
  MarksList(this.course);

  final Course course;

  @override
  _MarksListState createState() => _MarksListState(course);
}

class _MarksListState extends State<MarksList> {
  final Course _course;
  var showDetail = false;

  _MarksListState(this._course);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _course.assignments.length * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: 8,
          );
        }
        if (index.isOdd) {
          var assignment = _course.assignments[(index - 1) ~/ 2];

          return _MarksListTile(assignment);
        } else {
          return Divider();
        }
      },
    );
  }
}

class _MarksListTile extends StatefulWidget {
  final Assignment _assignment;

  _MarksListTile(this._assignment);

  @override
  _MarksListTileState createState() => _MarksListTileState(_assignment);
}

class _MarksListTileState extends State<_MarksListTile>
    with TickerProviderStateMixin {
  final Assignment _assignment;
  var showDetail = false;

  _MarksListTileState(this._assignment);

  @override
  Widget build(BuildContext context) {
    var summary = Row(
      key: Key("summary"),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child:
              Text(_assignment.name, style: Theme.of(context).textTheme.title),
        ),
        Flexible(child: SmallMarkChart(_assignment))
      ],
    );
    var detail = Column(
      key: Key("detail"),
      children: <Widget>[
        Text(
          _assignment.name,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 16,),
        SmallMarkChartDetail(_assignment)
      ],
    );

    return InkWell(
      onTap: () {
        setState(() {
          showDetail = !showDetail;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSize(
          vsync: this,
          curve: Curves.easeInOutCubic,
          child: AnimatedSwitcher(
              child: showDetail ? detail : summary,
              duration: Duration(milliseconds: 300)),
          duration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
