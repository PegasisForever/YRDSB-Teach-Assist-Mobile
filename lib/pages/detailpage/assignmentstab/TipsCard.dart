import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';

class TipsCard extends StatelessWidget {
  final String text;
  final VoidCallback onDismiss;

  TipsCard({@required this.text,@required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 6),
          child: Row(
            children: <Widget>[
              Icon(Icons.info_outline),
              SizedBox(
                width: 8,
              ),
              Expanded(child: Text(text)),
              FlatButton(
                child: Text(Strings.get("dismiss")),
                onPressed: onDismiss,
              )
            ],
          ),
        ),
      ),
    );
  }
}
//Strings.get("tap_to_view_detail")
