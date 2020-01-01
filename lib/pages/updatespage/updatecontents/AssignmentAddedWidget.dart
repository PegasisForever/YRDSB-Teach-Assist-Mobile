import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/pages/updatespage/updatecontents/ExpandableSmallMarkChart.dart';
import 'package:ta/pages/updatespage/updatecontents/UpdateWidgetTitle.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/DifferenceLPI.dart';

class AssignmentAddedWidget extends StatelessWidget {
  final AssignmentAdded update;

  AssignmentAddedWidget(this.update) : super(key: Key(update.hashCode.toString()));

  String getDescriptionText(){
    if(update.assignmentAvg != 100){
      return sprintf(Strings.get("u_got_avg_in_this_assi"), [num2Str(update.assignmentAvg)]);
    }else if(update.assignment.onlyHaveOneSmallMarkGroup){
      return Strings.get("u_got_full_in_this_assi");
    }else{
      return Strings.get("u_got_full_marks_in_this_assi");
    }
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
        if (update.assignmentAvg != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              getDescriptionText(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        SizedBox(
          height: 8,
        ),
        ExpandableSmallMarkChart(update.assignment),
        if (update.overallBefore != null && update.overallAfter != null)
          DifferenceLPI(update.overallBefore, update.overallAfter),
      ],
    );
  }
}
