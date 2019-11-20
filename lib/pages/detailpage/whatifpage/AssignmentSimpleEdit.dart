import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/widgets/StickSlider.dart';

class SimpleEdit extends StatefulWidget {
  final Assignment assignment;
  final WeightTable weights;
  final ValueChanged<Assignment> onChanged;

  SimpleEdit({this.assignment, this.weights, this.onChanged});

  @override
  SimpleEditState createState() => SimpleEditState();
}

class SimpleEditState extends State<SimpleEdit> {
  @override
  Widget build(BuildContext context) {
    var assi = widget.assignment;
    var avg = assi.getAverage(widget.weights);
    var avgWeight = assi.getAverageWeight();
    var available = assi.isAvailable();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StickSliderTile(
          enabled: available,
          value: avg ?? 0,
          min: 0,
          max: 100,
          label: "Average",
          labelWidth: 60,
          onChanged: (value) {
            widget.assignment
              ..KU.total = 100
              ..T.total = 100
              ..C.total = 100
              ..A.total = 100
              ..O.total = 100
              ..KU.get = value
              ..T.get = value
              ..C.get = value
              ..A.get = value
              ..O.get = value;

            widget.onChanged(widget.assignment);
          },
        ),
        StickSliderTile(
          enabled: available,
          value: avgWeight ?? 0,
          min: 0,
          label: "Weight",
          labelWidth: 60,
          onChanged: (value) {
            widget.assignment
              ..KU.weight = value
              ..T.weight = value
              ..C.weight = value
              ..A.weight = value
              ..O.weight = value;
            widget.onChanged(widget.assignment);
          },
        )
      ],
    );
  }
}
