import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ta/pages/setuppage/ImageChooser.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class SetShowRecentUpdate extends StatefulWidget {
  @override
  _SetShowRecentUpdateState createState() => _SetShowRecentUpdateState();
}

class _SetShowRecentUpdateState extends State<SetShowRecentUpdate> {
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
            Strings.get("show_recent_updates?"),
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TwoWidgetChooser(
                  width: 124,
                  height: 218,
                  value: false,
                  groupValue: Config.showRecentUpdates,
                  selected: !Config.showRecentUpdates,
                  child: Image.asset(
                    "assets/icons/dont_show_recent_updates_${isLightMode(context: context) ? "light" : "dark"}.png",
                    width: 120,
                  ),
                  onSelected: (value) => setState(() {
                    Config.showRecentUpdates = !value;
                  }),
                ),
                SizedBox(width: 32),
                TwoWidgetChooser(
                  width: 124,
                  height: 218,
                  value: true,
                  groupValue: Config.showRecentUpdates,
                  selected: Config.showRecentUpdates,
                  child: Image.asset(
                    "assets/icons/show_recent_updates_${isLightMode(context: context) ? "light" : "dark"}.png",
                    width: 120,
                  ),
                  onSelected: (value) => setState(() {
                    Config.showRecentUpdates = value;
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
