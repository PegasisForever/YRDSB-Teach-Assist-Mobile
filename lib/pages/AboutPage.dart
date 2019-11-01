import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ta/packageinfo.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends BetterState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("about")),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: <Widget>[
            Image.asset(
              "assets/images/app_logo.png",
              height: 130,
            ),
            Center(
              child: Text(
                "YRDSB Teach Assist",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Center(
              child: Text(
                packageInfo.version,
                style: TextStyle(
                    color: isLightMode(context)
                        ? Colors.grey[600]
                        : Colors.grey[400]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          "The next-gen Teach Assist client for YRDSB. Project link: ",
                      style: Theme.of(context).textTheme.body1),
                  TextSpan(
                      text: "dev.pegasis.site/ta",
                      recognizer: TapGestureRecognizer()..onTap = () {
                        launch("https://dev.pegasis.site/ta");
                        print("lunch");
                      },
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      )),
                ]),
              ),
            ),
            SizedBox(
              height: 250,
            ),
            Center(
              child: Text(
                "Made by Pegasis with ❤️",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
