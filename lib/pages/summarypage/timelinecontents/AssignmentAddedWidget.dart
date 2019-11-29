import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/summarypage/timelinecontents/ExpandableSmallMarkChart.dart';
import 'package:ta/pages/summarypage/timelinecontents/UpdateWidgetTitle.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;

class AssignmentAddedWidget extends StatelessWidget {
  final AssignmentAdded update;
  String average;

  AssignmentAddedWidget(this.update, Map weightTableMap)
      : super(key: Key(update.hashCode.toString())) {
    var weightTable =
        weightTableMap.containsKey(update.courseName) ? weightTableMap[update.courseName] : null;
    if (weightTable != null) average = num2Str(update.assignment.getAverage(weightTable));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        UpdateWidgetTitle(
          subTitle: update.courseName,
          title: update.assignment.displayName,
          icon: Icon(
            Icons.note_add,
            size: 32,
            color: Colors.green,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        if (average != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              sprintf(Strings.get("u_got_avg_in_this_assi"), [average]),
              style: TextStyle(fontSize: 16),
            ),
          ),
        SizedBox(
          height: 8,
        ),
        ExpandableSmallMarkChart(update.assignment),
        (update.overallBefore != null && update.overallBefore != update.overallAfter)
            ? Column(
          children: <Widget>[
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  num2Str(update.overallBefore) + "%",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward, size: 32),
                Text(num2Str(update.overallAfter) + "%",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            update.overallBefore > update.overallAfter
                ? LPI.LinearProgressIndicator(
              lineHeight: 20.0,
              value1: update.overallAfter / 100,
              value2: update.overallBefore / 100,
              value1Color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              value2Color: Colors.red[400],
            )
                : LPI.LinearProgressIndicator(
              lineHeight: 20.0,
              value1: update.overallBefore / 100,
              value2: update.overallAfter / 100,
              value1Color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              value2Color: Colors.green,
            ),
          ],
        )
            : Container(),
      ],
    );
  }
}
