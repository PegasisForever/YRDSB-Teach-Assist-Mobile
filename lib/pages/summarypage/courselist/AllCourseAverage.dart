import 'package:flutter/material.dart' hide LinearProgressIndicator;
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart';

class AllCourseAverage extends StatelessWidget {
  final double avg;
  AllCourseAverage(this.avg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.get("average"),
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            num2Str(avg) + "%",
            style: TextStyle(fontSize: 60),
          ),
          LinearProgressIndicator(
            animationDuration: 700,
            lineHeight: 20.0,
            value1: avg / 100,
            value1Color: primaryColorOf(context),
          ),
        ],
      ),
    );
  }
}
