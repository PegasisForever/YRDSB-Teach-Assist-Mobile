import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChart.dart';
import 'package:ta/pages/detailpage/assignmentstab/SmallMarkChartDetail.dart';
import 'package:ta/widgets/CrossFade.dart';

class ExpandableSmallMarkChart extends StatefulWidget {
  final Assignment assignment;

  ExpandableSmallMarkChart(this.assignment);

  @override
  _ExpandableSmallMarkChartState createState() => _ExpandableSmallMarkChartState();
}

class _ExpandableSmallMarkChartState extends State<ExpandableSmallMarkChart> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CrossFade(
        firstChild: Center(
          heightFactor: 1,
          widthFactor: double.infinity,
          child: SmallMarkChart(widget.assignment),
        ),
        secondChild: SmallMarkChartDetail(widget.assignment),
        showFirst: !expanded,
      ),
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
    );
  }
}
