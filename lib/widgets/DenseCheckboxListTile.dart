import 'package:flutter/material.dart';

class DenseCheckboxListTile extends StatelessWidget {
  final Widget text;
  final bool value;
  final ValueChanged<bool> onChanged;

  DenseCheckboxListTile({this.text, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            text,
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
