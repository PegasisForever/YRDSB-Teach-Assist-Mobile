import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/summarypage/timelinecontents/ExpandableSmallMarkChart.dart';
import 'package:ta/pages/summarypage/timelinecontents/UpdateWidgetTitle.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

import 'DifferenceLPI.dart';

class AssignmentUpdatedWidget extends StatelessWidget {
  final AssignmentUpdated update;

  AssignmentUpdatedWidget(this.update) : super(key: Key(update.hashCode.toString()));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        UpdateWidgetTitle(
          subTitle: update.courseName,
          title: update.assignmentName,
          icon: Icon(
            Icons.edit,
            size: 32,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        getDiscText(),
        SizedBox(height: 8),
        ExpandableSmallMarkChart(update.assignmentAfter),
        if (update.overallBefore != null && update.overallAfter != null)
          DifferenceLPI(update.overallBefore, update.overallAfter),
      ],
    );
  }

  Widget getDiscText() {
    String str;
    var avgBefore = update.assignmentAvgBefore;
    var avgAfter = update.assignmentAvgAfter;
    if (avgBefore != null && avgAfter != null) {
      if (avgBefore > avgAfter) {
        str = sprintf(
          Strings.get("ur_avg_of_this_assi_dropped"),
          [num2Str(avgBefore), num2Str(avgAfter)],
        );
      } else if (avgBefore < avgAfter) {
        str = sprintf(
          Strings.get("ur_avg_of_this_assi_increased"),
          [num2Str(avgBefore), num2Str(avgAfter)],
        );
      } else {
        str = Strings.get("ur_avg_of_this_assi_didnt_change");
      }
    } else if (avgBefore == null && avgAfter != null) {
      str = sprintf(Strings.get("ur_new_avg_of_this_assi"), [num2Str(avgAfter)]);
    }

    return str == null ? Container() : Text(str, style: TextStyle(fontSize: 16));
  }
}
