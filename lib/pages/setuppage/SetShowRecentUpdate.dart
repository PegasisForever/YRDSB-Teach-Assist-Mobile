import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Strings.get("show_recent_updates?"),
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 70),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ScreenDemo(
              path: "dont_show_recent_updates",
              value: false,
              selected: !Config.showRecentUpdates,
              onSelected: (value) => setState(() {
                Config.showRecentUpdates = !value;
              }),
            ),
            SizedBox(width: 32),
            _ScreenDemo(
              path: "show_recent_updates",
              value: true,
              selected: Config.showRecentUpdates,
              onSelected: (value) => setState(() {
                Config.showRecentUpdates = value;
              }),
            ),
          ],
        ),
      ],
    );
  }
}

typedef BoolCallback = void Function(bool value);

class _ScreenDemo extends StatelessWidget {
  final String path;
  final bool selected;
  final BoolCallback onSelected;
  final bool value;

  _ScreenDemo({this.path, this.selected, this.onSelected, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 124,
          height: 218,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                child: AnimatedContainer(
                  child: Image.asset(
                    "assets/icons/${path}_${isLightMode(context: context) ? "light" : "dark"}.png",
                    width: 120,
                  ),
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: selected ? getPrimary() : getGrey(-100),
                        width: selected ? 2 : 1),
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
          groupValue: Config.showRecentUpdates,
          onChanged: (value) {
            onSelected(value == this.value);
          },
        )
      ],
    );
  }
}
