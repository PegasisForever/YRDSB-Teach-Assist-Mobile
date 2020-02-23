import 'package:flutter/material.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends BetterState<SetupPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var sidePadding = (widthOf(context) - 400) / 2;
    var topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: Colors.blue,
              ),
              Container(
                width: double.infinity,
                color: Colors.green,
              ),
              Container(
                width: double.infinity,
                color: Colors.amber,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topPadding + 4,
              left: 4,
            ),
            child: IconButton(
              icon: Icon(isAndroid() ? Icons.arrow_back : Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
