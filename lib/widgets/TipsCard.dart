import 'package:flutter/material.dart';

class TipsCard extends StatelessWidget {
  final String text;
  final Widget leading;
  final Widget trailing;
  final EdgeInsets padding;

  TipsCard({this.text, this.leading, this.trailing, this.padding});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            leading ?? Container(),
            SizedBox(
              width: 8,
            ),
            Expanded(child: Text(text)),
            trailing ?? Container()
          ],
        ),
      ),
    );
  }
}

