import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/ColorPad.dart';

class SetColor extends StatefulWidget {
  @override
  _SetColorState createState() => _SetColorState();
}

class _SetColorState extends State<SetColor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          Strings.get("select_a_primary_color"),
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 150),
        ColorPad(),
      ],
    );
  }
}
