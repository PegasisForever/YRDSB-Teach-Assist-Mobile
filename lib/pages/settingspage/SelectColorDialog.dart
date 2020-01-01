import 'package:flutter/material.dart';
import 'package:ta/main.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';

class SelectColorDialog extends StatefulWidget {
  @override
  _SelectColorDialogState createState() => _SelectColorDialogState();
}

class _SelectColorDialogState extends State<SelectColorDialog> {
  @override
  Widget build(BuildContext context) {
    var colorItems = List<Widget>();
    ColorMap.forEach((name, color) {
      colorItems.add(_ColorItem(color, () {
        App.updateColor(color);
        Navigator.pop(context);
      }));
    });

    return AlertDialog(
      title: Text(Strings.get("select_a_primary_color")),
      contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16),
      content: Center(
        heightFactor: 1,
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: colorItems,
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

class _ColorItem extends StatelessWidget {
  final MaterialColor color;
  final Function onTap;

  _ColorItem(this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 32,
          height: 32,
          decoration: new BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
