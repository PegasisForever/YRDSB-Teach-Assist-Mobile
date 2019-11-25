import 'package:flutter/material.dart';
import 'package:ta/res/CustomIcons.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class ArchivedCoursesPage extends StatefulWidget {
  @override
  _ArchivedCoursesPageState createState() => _ArchivedCoursesPageState();
}

class _ArchivedCoursesPageState extends State<ArchivedCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("archived_marks")),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: _AwardBar(0, 0, 0),
          ),
          Expanded(
            child: Center(
              child: Text(
                Strings.get(
                  "no_archived_courses",
                ),
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AwardBar extends StatelessWidget {
  final int bronze;
  final int silver;
  final int gold;

  _AwardBar(this.bronze, this.silver, this.gold);

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
                number: 0,
                min: 80,
              ),
              _Award(
                color: Color.fromARGB(255, 180, 180, 180),
                number: 0,
                min: 90,
              ),
              _Award(
                color: Color.fromARGB(255, 245, 205, 0),
                number: 0,
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
