import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_privacy_screen/flutter_privacy_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:ta/licence.dart';
import 'package:ta/main.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/plugins/firebase.dart';
import 'package:ta/plugins/packageinfo.dart';

Function appLoadDone;

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> with AfterLayoutMixin {
  var opacity = 0.0;
  var appLoaded = false;
  Widget app = Container();

  @override
  void initState() {
    super.initState();
    appLoadDone = this._appLoadDone;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(color: Color(0xff03a9f4)),
        AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 300),
          child: app,
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (appLoaded) return;
    await initPref();
    SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
    initPackageInfo();
    initFirebaseMsg();
    initUser();
    if (Config.hideAppContent) {
      FlutterPrivacyScreen.enablePrivacyScreen();
    }
    setState(() {
      app = App();
    });
  }

  void _appLoadDone() {
    if (appLoaded) return;
    setState(() {
      opacity = 1.0;
    });
    appLoaded = true;
  }
}
