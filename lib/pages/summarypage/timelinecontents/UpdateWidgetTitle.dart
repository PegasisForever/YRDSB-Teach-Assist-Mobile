import 'package:flutter/material.dart';

class UpdateWidgetTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final Icon icon;

  UpdateWidgetTitle({this.title, this.subTitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (subTitle != null) Text(subTitle),
              if (title != null) Text(title, style: Theme.of(context).textTheme.title),
            ],
          ),
        )
      ],
    );
  }
}
