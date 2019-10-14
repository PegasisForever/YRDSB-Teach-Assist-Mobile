import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/AccountsList.dart';
import 'package:ta/pages/EditAccount.dart';
import 'package:ta/pages/LoginPage.dart';
import 'package:ta/pages/summarypage/SummaryPage.dart';

import 'dataStore.dart';
import 'firebaseMsg.dart';

void main() async {
  initFirebaseMsg();
  await initPref();
  initUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
            primary: const Color(0xff03a9f4),
            primaryVariant: const Color(0xff007ac1),
            secondary: const Color(0xff40c4ff),
            secondaryVariant: const Color(0xff0094cc),
            onPrimary: Colors.white),
        accentColor: const Color(0xff40c4ff),
        primarySwatch: Colors.lightBlue),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => new SummaryPage(),
        "/login": (BuildContext context) => new LoginPage(),
        "/accounts_list": (BuildContext context) => new AccountsList(),
        "/accounts_list/edit": (BuildContext context) =>
            new EditAccount(User.blank()),
      },
      navigatorObservers: [
//        observer
      ],
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
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
