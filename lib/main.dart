import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_privacy_screen/flutter_privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:ta/licence.dart';
import 'package:ta/model/User.dart';
import 'package:ta/packageinfo.dart';
import 'package:ta/pages/LoginPage.dart';
import 'package:ta/pages/archivedpage/ArchivedCoursesPage.dart';
import 'package:ta/pages/detailpage/whatifpage/WhatIfWelcomePage.dart';
import 'package:ta/pages/drawerpages/AboutPage.dart';
import 'package:ta/pages/drawerpages/AccountsList.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/pages/drawerpages/FeedbackPage.dart';
import 'package:ta/pages/settingspage/SettingsPage.dart';
import 'package:ta/pages/summarypage/SummaryPage.dart';

import 'dataStore.dart';
import 'firebase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    await initPref();
    SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
    initPackageInfo();
    initFirebaseMsg();
    FlutterPrivacyScreen.enablePrivacyScreen();
    initUser();

    runApp(App());
  }, onError: Crashlytics.instance.recordError);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

  static Function updateBrightness;
  static Function updateColor;
}

class _AppState extends State<App> {
  _updateBrightness(int v) {
    setState(() {
      Config.darkMode = v;
    });
  }

  _updateColor(MaterialColor color) {
    setState(() {
      Config.primaryColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    App.updateBrightness = _updateBrightness;
    App.updateColor = _updateColor;
  }

  @override
  Widget build(BuildContext context) {
    var color = Config.primaryColor;
    ThemeData lightTheme;
    ThemeData darkTheme;
    switch (Config.darkMode) {
      case 0:
        {
          lightTheme = getLightTheme(color);
          darkTheme = getLightTheme(color);
        }
        break;
      case 1:
        {
          lightTheme = getLightTheme(color);
          darkTheme = getDarkTheme(color);
        }
        break;
      case 2:
        {
          lightTheme = getDarkTheme(color);
          darkTheme = getDarkTheme(color);
        }
        break;
    }

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YRDSB Teach Assist',
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => SummaryPage(),
        "/login": (BuildContext context) => LoginPage(),
        "/accounts_list": (BuildContext context) => AccountsList(),
        "/accounts_list/edit": (BuildContext context) => EditAccount(User.blank(), false),
        "/about": (BuildContext context) => AboutPage(),
        "/feedback": (BuildContext context) => FeedbackPage(),
        "/whatif_welcome": (BuildContext context) => WhatIfWelcomePage(),
        "/archived_course": (BuildContext context) => ArchivedCoursesPage(),
        "/settings": (BuildContext context) => SettingsPage(),
      },
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale.fromSubtags(languageCode: 'zh')],
    );
  }

  ThemeData getLightTheme(MaterialColor color) {
    return ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: color,
          secondary: color[200],
        ),
        accentColor: color,
        primaryColor: color,
        primaryColorDark: color[700],
        toggleableActiveColor: color,
        appBarTheme: AppBarTheme(color: color),
        textSelectionColor: color[200],
        textSelectionHandleColor: color,
        cursorColor: color,
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(
            primary: color[400],
            secondary: color[200],
          ),
        ),
        sliderTheme: SliderThemeData(
          disabledActiveTrackColor: Colors.grey[400],
          disabledInactiveTrackColor: Colors.grey[400],
          disabledThumbColor: Colors.grey[500],
          activeTrackColor: color[200],
          inactiveTrackColor: color[200],
          thumbColor: color,
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        ));
  }

  ThemeData getDarkTheme(MaterialColor color) {
    return ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: color,
          secondary: color[300],
        ),
        accentColor: color,
        toggleableActiveColor: color[300],
        textSelectionColor: color,
        textSelectionHandleColor: color[300],
        cursorColor: color,
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.dark(
            primary: color[400],
            secondary: color[200],
          ),
        ),
        primarySwatch: color,
        sliderTheme: SliderThemeData(
          disabledActiveTrackColor: Colors.grey[500],
          disabledInactiveTrackColor: Colors.grey[500],
          disabledThumbColor: Colors.grey[600],
          activeTrackColor: color[300],
          inactiveTrackColor: color[300],
          thumbColor: color,
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        ));
  }
}
