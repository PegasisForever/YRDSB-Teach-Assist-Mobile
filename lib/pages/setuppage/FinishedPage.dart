import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';

class FinishedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Strings.get("setup_wizard_finished"),
          style: TextStyle(fontSize: 32),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          Strings.get("u_can_reopen_this_page_later_in_the_settings"),
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
