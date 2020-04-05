import 'package:flutter/material.dart';
import 'package:ta/pages/setuppage/ImageChooser.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';

class SetShowMoreDecimalPlaces extends StatefulWidget {
  @override
  _SetShowMoreDecimalPlacesState createState() => _SetShowMoreDecimalPlacesState();
}

class _SetShowMoreDecimalPlacesState extends State<SetShowMoreDecimalPlaces> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Strings.get("show_more_decimal_places?"),
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 70),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TwoWidgetChooser(
              width: 124,
              height: 64,
              value: false,
              groupValue: Config.showMoreDecimal,
              selected: !Config.showMoreDecimal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "99.9%",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              onSelected: (value) => setState(() {
                Config.showMoreDecimal = !value;
              }),
            ),
            SizedBox(width: 32),
            TwoWidgetChooser(
              width: 124,
              height: 64,
              value: true,
              groupValue: Config.showMoreDecimal,
              selected: Config.showMoreDecimal,
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "99.99%",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              onSelected: (value) => setState(() {
                Config.showMoreDecimal = value;
              }),
            ),
          ],
        ),
      ],
    );
  }
}
