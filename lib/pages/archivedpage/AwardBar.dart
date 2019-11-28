import 'package:flutter/material.dart';
import 'package:ta/res/CustomIcons.dart';

import '../../tools.dart';

class AwardBar extends StatelessWidget {
  final int bronze;
  final int silver;
  final int gold;

  AwardBar(this.bronze, this.silver, this.gold);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _Award(
                color: Color.fromARGB(255, 205, 127, 50),
                number: bronze,
                min: 80,
              ),
              _Award(
                color: Color.fromARGB(255, 180, 180, 180),
                number: silver,
                min: 90,
              ),
              _Award(
                color: Color.fromARGB(255, 245, 205, 0),
                number: gold,
                min: 99,
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _Award extends StatelessWidget {
  final Color color;
  final int number;
  final int min;

  _Award({this.color, this.number, this.min = 90});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          CustomIcons.award,
          color: color,
          size: 48,
        ),
        SizedBox(
          width: 4,
        ),
        Column(
          children: <Widget>[
            Text(
              number.toString(),
              style: TextStyle(
                fontSize: 32,
                height: 1,
              ),
            ),
            Text(
              "≥" + min.toString(),
              style: TextStyle(
                fontSize: 12,
                height: 1,
                color: isLightMode(context: context) ? Colors.grey[700] : Colors.grey[400],
              ),
            ),
          ],
        )
      ],
    );
  }
}
