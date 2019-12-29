import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_privacy_screen/flutter_privacy_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/plugins/firebase.dart';
import 'package:ta/licence.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/packageinfo.dart';
import 'package:ta/pages/LoginPage.dart';
import 'package:ta/pages/archivedpage/ArchivedCoursesPage.dart';
import 'package:ta/pages/calendarpage/CalendarPage.dart';
import 'package:ta/pages/detailpage/DetailPage.dart';
import 'package:ta/pages/detailpage/whatifpage/WhatIfWelcomePage.dart';
import 'package:ta/pages/drawerpages/AboutPage.dart';
import 'package:ta/pages/drawerpages/AccountsList.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/pages/drawerpages/FeedbackPage.dart';
import 'package:ta/pages/settingspage/SettingsPage.dart';
import 'package:ta/pages/summarypage/SummaryPage.dart';
import 'package:ta/pages/updatespage/UpdatesPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    await initPref();
    SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
    initPackageInfo();
    initFirebaseMsg();
    if (Config.hideAppContent) {
      FlutterPrivacyScreen.enablePrivacyScreen();
    }
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
      initialRoute: "/",
      onGenerateRoute: generateRoute,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale.fromSubtags(languageCode: 'zh')],
    );
  }

  Route generateRoute(RouteSettings settings) {
    final args = settings.arguments as List;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => userList.length == 0 ? LoginPage() : SummaryPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginPage());
      case "/updates":
        return MaterialPageRoute(builder: (_) => UpdatesPage());
      case "/calendar":
        return MaterialPageRoute(builder: (_) => CalendarPage());
      case "/accounts_list":
        return MaterialPageRoute(builder: (_) => AccountsList());
      case "/accounts_list/edit":
        return MaterialPageRoute(builder: (_) => EditAccount(args[0], args[1]));
      case "/about":
        return MaterialPageRoute(builder: (_) => AboutPage());
      case "/feedback":
        return MaterialPageRoute(builder: (_) => FeedbackPage());
      case "/detail":
        return MaterialPageRoute(builder: (_) => DetailPage(args[0]));
      case "/detail/whatif_welcome":
        return MaterialPageRoute(builder: (_) => WhatIfWelcomePage());
      case "/archived":
        return MaterialPageRoute(builder: (_) => ArchivedCoursesPage());
      case "/settings":
        return MaterialPageRoute(builder: (_) => SettingsPage());
    }
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
      appBarTheme: AppBarTheme(
        color: ThemeData.light().canvasColor,
        brightness: Brightness.light,
        elevation: 0,
      ),
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
      ),
    );
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
      appBarTheme: AppBarTheme(
        color: ThemeData.dark().canvasColor,
        brightness: Brightness.dark,
        elevation: 0,
      ),
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
      ),
    );
  }
}
