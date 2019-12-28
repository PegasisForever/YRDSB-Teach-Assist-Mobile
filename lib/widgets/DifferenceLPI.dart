import 'package:flutter/material.dart' hide LinearProgressIndicator;
import 'package:ta/tools.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart';

class DifferenceLPI extends StatelessWidget {
  DifferenceLPI(this.value1, this.value2);

  final double value1;
  final double value2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              num2Str(value1) + "%",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_forward, size: 32),
            Text(
              num2Str(value2) + "%",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        value1 > value2
            ? LinearProgressIndicator(
                lineHeight: 20.0,
                value1: value2 / 100,
                value2: value1 / 100,
                value1Color: Theme.of(context).colorScheme.secondary,
                value2Color: Colors.red[400],
              )
            : LinearProgressIndicator(
                lineHeight: 20.0,
                value1: value1 / 100,
                value2: value2 / 100,
                value1Color: Theme.of(context).colorScheme.secondary,
                value2Color: Colors.green,
              ),
      ],
    );
  }
}
