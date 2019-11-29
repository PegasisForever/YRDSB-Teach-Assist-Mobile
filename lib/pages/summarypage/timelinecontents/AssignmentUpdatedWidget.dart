import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/summarypage/timelinecontents/ExpandableSmallMarkChart.dart';
import 'package:ta/pages/summarypage/timelinecontents/UpdateWidgetTitle.dart';
import 'package:ta/tools.dart';

class AssignmentUpdatedWidget extends StatelessWidget {
  final AssignmentUpdated update;
  String averageBefore;
  String averageAfter;

  AssignmentUpdatedWidget(this.update, Map weightTableMap)
      : super(key: Key(update.hashCode.toString())) {
    var weightTable =
        weightTableMap.containsKey(update.courseName) ? weightTableMap[update.courseName] : null;
    if (weightTable != null) {
      averageBefore = num2Str(update.assignmentBefore.getAverage(weightTable));
      averageAfter = num2Str(update.assignmentAfter.getAverage(weightTable));
    }
  }

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
        SizedBox(height: 8),
      ],
    );
  }

  Widget getDiscText() {
    if (averageAfter != null && averageAfter != "NaN") {
      var str = "";
      if (averageBefore == null || averageBefore == "NaN") {
        str = "Your new average of this assessment is $averageAfter%.";
      } else {
        str = "Your average of this assessment changed from $averageBefore% to $averageAfter%.";
      }
      return Text(
        str,
        style: TextStyle(fontSize: 16),
      );
    } else {
      return Container();
    }
  }
}
