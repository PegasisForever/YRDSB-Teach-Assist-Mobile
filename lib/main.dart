import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ta/model/User.dart';
import 'package:ta/packageinfo.dart';
import 'package:ta/pages/LoginPage.dart';
import 'package:ta/pages/drawerpages/AboutPage.dart';
import 'package:ta/pages/drawerpages/AccountsList.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/pages/drawerpages/FeedbackPage.dart';
import 'package:ta/pages/summarypage/SummaryPage.dart';

import 'dataStore.dart';
import 'firebase.dart';

void main() {
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned<Future<void>>(() async {
    await initPackageInfo();
    initFirebaseMsg();
    await initPref();
    initUser();

    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'YRDSB Teach Assist',
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
              primary: const Color(0xff03a9f4),
              primaryVariant: const Color(0xff007ac1),
              secondary: const Color(0xff80d8ff),
              secondaryVariant: const Color(0xff49a7cc),
              onPrimary: Colors.white),
          accentColor: const Color(0xff40c4ff),
          toggleableActiveColor: const Color(0xff03a9f4),
          buttonTheme:
          ButtonThemeData(colorScheme: ColorScheme.light(secondary: const Color(0xff03a9f4)))),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
              primary: const Color(0xff03a9f4),
              primaryVariant: const Color(0xff007ac1),
              secondary: const Color(0xff40c4ff),
              secondaryVariant: const Color(0xff0094cc),
              onPrimary: Colors.white),
          accentColor: const Color(0xff40c4ff),
          toggleableActiveColor: const Color(0xff40c4ff),
          primarySwatch: Colors.lightBlue),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => SummaryPage(),
        "/login": (BuildContext context) => LoginPage(),
        "/accounts_list": (BuildContext context) => AccountsList(),
        "/accounts_list/edit": (BuildContext context) => EditAccount(User.blank(), false),
        "/about": (BuildContext context) => AboutPage(),
        "/feedback": (BuildContext context) => FeedbackPage(),
      },
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale.fromSubtags(languageCode: 'zh')],
    );
  }
}
