import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChartDetail.dart';
import 'package:ta/res/Strings.dart';

import '../../../tools.dart';
import 'SmallMarkChart.dart';

class MarksList extends StatefulWidget {
  MarksList(this._course);

  final Course _course;

  @override
  _MarksListState createState() => _MarksListState(_course);
}

class _MarksListState extends State<MarksList> {
  final Course _course;
  var showDetail = false;

  _MarksListState(this._course);

  @override
  Widget build(BuildContext context) {
    return _course.overallMark!=null?ListView.builder(
      cacheExtent:double.maxFinite,
      itemCount: _course.assignments.length * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: 8,
          );
        }
        if (index.isOdd) {
          var assignment = _course.assignments[(index - 1) ~/ 2];
          return _MarksListTile(assignment,_course.weights);
        } else {
          return Divider();
        }
      },
    ):Center(
      child: Text(Strings.get("assignments_unavailable"),style: Theme.of(context).textTheme.subhead,),
    );
  }
}

class _MarksListTile extends StatefulWidget {
  final Assignment _assignment;
  final Weights _weights;

  _MarksListTile(this._assignment,this._weights);

  @override
  _MarksListTileState createState() => _MarksListTileState(_assignment,_weights);
}

class _MarksListTileState extends State<_MarksListTile>
    with TickerProviderStateMixin {
  final Assignment _assignment;
  final Weights _weights;
  var showDetail = false;

  _MarksListTileState(this._assignment,this._weights);

  @override
  Widget build(BuildContext context) {
    var avg=_assignment.getAverage(_weights);
    var avgText=avg==null?SizedBox(width: 0,height: 0):Text(Strings.get("avg:")+_assignment.getAverage(_weights),style: TextStyle(fontSize: 16,color: Colors.grey));

    bool noWeight=isZeroOrNull(_assignment.KU.weight) &&
        isZeroOrNull(_assignment.T.weight) &&
        isZeroOrNull(_assignment.C.weight) &&
        isZeroOrNull(_assignment.A.weight) &&
        isZeroOrNull(_assignment.F.weight) &&
        isZeroOrNull(_assignment.O.weight);
    var noWeightText=noWeight?Text(Strings.get("no_weight"),style: TextStyle(fontSize: 16,color: Colors.grey)):SizedBox(width: 0,height: 0);

    var summary = Row(
      key: Key("summary"),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_assignment.beautifulName, style: Theme.of(context).textTheme.title),
              SizedBox(height: 4,),
              avgText,
              noWeightText
            ],
          ),
        ),
        Flexible(child: SmallMarkChart(_assignment))
      ],
    );
    var detail = Column(
      key: Key("detail"),
      children: <Widget>[
        Text(
          _assignment.beautifulName,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 4,),
        avgText,
        SizedBox(height: 12,),
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
