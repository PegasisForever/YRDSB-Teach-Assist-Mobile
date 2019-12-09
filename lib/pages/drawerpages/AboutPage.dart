import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ta/packageinfo.dart';
import 'package:ta/pages/drawerpages/OpenCustomTab.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends BetterState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var sidePadding = (widthOf(context) - 500) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("about")),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            horizontal: (sidePadding > 0 ? sidePadding : 0)+24.0,
          ),
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/app_logo.png"),
              height: 130,
              width: 130,
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
                    color: isLightMode(context: context) ? Colors.grey[600] : Colors.grey[400]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text("Developed by students for students."),
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: Strings.get("project_description"),
                      style: Theme.of(context).textTheme.body1),
                  TextSpan(
                      text: "dev.pegasis.site/ta",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => openCustomTab(context,"https://dev.pegasis.site/ta"),
                      style: TextStyle(
                        color: isLightMode(context: context)?Colors.blue:Colors.blue[300],
                        decoration: TextDecoration.underline,
                      )),
                ]),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    openCustomTab(context, "https://ta-yrdsb.web.app/privacy-policy");
                  },
                  textColor: isLightMode(context: context) ? Colors.grey[800] : Colors.grey[300],
                  icon: Icon(Icons.chrome_reader_mode),
                  label: Text(Strings.get("privacy_policy")),
                ),
                FlatButton.icon(
                  onPressed: () {
                    openCustomTab(context, "https://ta-yrdsb.web.app/support");
                  },
                  textColor: isLightMode(context: context) ? Colors.grey[800] : Colors.grey[300],
                  icon: Icon(Icons.live_help),
                  label: Text(Strings.get("support")),
                ),
              ],
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
