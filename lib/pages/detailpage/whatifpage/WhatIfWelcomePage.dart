import 'package:flutter/material.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

import '../../../CustomIcons.dart';

class WhatIfWelcomePage extends StatefulWidget {
  @override
  _WhatIfWelcomePageState createState() => _WhatIfWelcomePageState();
}

class _WhatIfWelcomePageState extends BetterState<WhatIfWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                icon: Icon(isAndroid() ? Icons.arrow_back : Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(CustomIcons.lightbulb_shine, size: 64, color: Colors.amber),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "What If .....",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  FlatButton.icon(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "I got a new mark",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                      ),
                    ),
                    icon: Icon(Icons.add_to_photos),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton.icon(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Teacher updated my mark",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                      ),
                    ),
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
