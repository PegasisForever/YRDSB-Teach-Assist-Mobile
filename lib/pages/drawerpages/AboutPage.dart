import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ta/packageinfo.dart';
import 'package:ta/pages/drawerpages/OpenCustomTab.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';
import 'package:transparent_image/transparent_image.dart';
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
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage("assets/images/app_logo.png"),
              height: 130,
              width: 130,
              fadeInDuration: const Duration(milliseconds: 100),
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
                        ..onTap = () {
                          launch("https://dev.pegasis.site/ta");
                        },
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      )),
                ]),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            FlatButton.icon(
              onPressed: () {
                openCustomTab(context, "https://ta-yrdsb.web.app/privacy-policy");
              },
              textColor: isLightMode(context: context) ? Colors.grey[800] : Colors.grey[300],
              icon: Icon(Icons.chrome_reader_mode),
              label: Text("Privacy Policy"),
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
