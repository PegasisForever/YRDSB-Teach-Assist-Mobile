import 'package:flutter/material.dart';
import 'package:ta/tools.dart';

typedef _BoolCallback = void Function(bool value);

class TwoWidgetChooser extends StatelessWidget {
  final bool selected;
  final _BoolCallback onSelected;
  final bool value;
  final bool groupValue;
  final double width;
  final double height;
  final Widget child;

  TwoWidgetChooser({
    this.selected,
    this.onSelected,
    this.value,
    this.groupValue,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                child: AnimatedContainer(
                  child: child,
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    border: Border.all(color: selected ? getPrimary() : getGrey(-100), width: selected ? 2 : 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onTap: () {
                  onSelected(true);
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (value) {
            onSelected(value == this.value);
          },
        )
      ],
    );
  }
}
