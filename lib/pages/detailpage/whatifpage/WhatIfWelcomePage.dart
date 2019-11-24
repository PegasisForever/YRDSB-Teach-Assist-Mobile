import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
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
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shrinkWrap: true,
                children: <Widget>[
                  Icon(CustomIcons.lightbulb_shine, size: 64, color: Colors.amber),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Strings.get("what_if..."),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(Strings.get("i_got_a_new_mark"),
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                  SizedBox(
                    height: 6,
                  ),
                  Text(Strings.get("teacher_updated_my_mark"),
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                  SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      Strings.get("what_if_description"),
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: FlatButton(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Text(Strings.get("enable_what_if_mode"),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
