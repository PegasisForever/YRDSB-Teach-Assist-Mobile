import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/ColorPad.dart';

class SelectColorDialog extends StatefulWidget {
  @override
  _SelectColorDialogState createState() => _SelectColorDialogState();
}

class _SelectColorDialogState extends State<SelectColorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.get("select_a_primary_color")),
      contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16),
      content: Center(
        heightFactor: 1,
        child: ColorPad(
          onColorChose: () => Navigator.pop(context),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(Strings.get("cancel").toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

