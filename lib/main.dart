import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/AccountsList.dart';
import 'package:ta/pages/EditAccount.dart';
import 'package:ta/pages/LoginPage.dart';
import 'package:ta/pages/SummaryPage.dart';

import 'dataStore.dart';
import 'firebaseMsg.dart';

void main() async {
  initFirebaseMsg();
  await initPref();
  initUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'YRDSB Teach Assist',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue,
          accentColor: Color.fromARGB(255, 129, 212, 250)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue,
          accentColor: Color.fromARGB(255, 129, 212, 250)),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => new SummaryPage(),
        "/login": (BuildContext context) => new LoginPage(),
        "/accounts_list": (BuildContext context) => new AccountsList(),
        "/accounts_list/edit": (BuildContext context) => new EditAccount(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh')
      ],
    );
  }
}
