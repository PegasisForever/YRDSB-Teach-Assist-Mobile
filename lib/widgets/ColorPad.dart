import 'package:flutter/material.dart';
import 'package:ta/main.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/tools.dart';

class _ColorItem extends StatelessWidget {
  final MaterialColor color;
  final Function onTap;
  final bool selected;

  _ColorItem({this.color, this.onTap, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: selected ? getGrey(-200) : Colors.transparent,
          borderRadius: BorderRadius.all(const Radius.circular(4))
      ),
      child: InkWell(
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
      ),
    );
  }
}

class ColorPad extends StatelessWidget {
  final VoidCallback onColorChose;

  ColorPad({this.onColorChose});

  @override
  Widget build(BuildContext context) {
    var colorItems = List<Widget>();
    var primaryColor = Config.primaryColor;
    ColorMap.forEach((name, color) {
      colorItems.add(_ColorItem(
        color: color,
        onTap: () {
          App.updateColor(color);
          if (onColorChose != null) onColorChose();
        },
        selected: color == primaryColor,
      ));
    });
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: colorItems,
    );
  }
}
