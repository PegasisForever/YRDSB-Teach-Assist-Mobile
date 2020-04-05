import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/ColorPad.dart';

class SetColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 0,
          child: SizedBox(height: 32),
        ),
        Flexible(
          flex: 0,
          child: Text(
            Strings.get("select_a_primary_color"),
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Center(
            child: ColorPad(),
          ),
        ),
      ],
    );
  }
}
