import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ta/res/Strings.dart';

import 'dataStore.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler(this.resumeCallBack);

  final AsyncCallback resumeCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await resumeCallBack();
    }
    return;
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  Scaffold.of(context).showSnackBar(snackBar);
}

String getRoundString(double num, int digit) {
  var str = num.toStringAsFixed(digit);
  while (str[str.length - 1] == "0") {
    str = str.substring(0, str.length - 1);

    if (str[str.length - 1] == ".") {
      str = str.substring(0, str.length - 1);
      break;
    }
  }

  return str;
}

String num2Str(num num) {
  if (num == null) return null;
  if (!num.isNaN) {
    var n = num.toDouble();
    return Config.showMoreDecimal ? n.toStringAsFixed(2) : getRoundString(n, 1);
  } else {
    return "NaN";
  }
}

double num2Round(num num) {
  if (num == null) return null;
  var factor = Config.showMoreDecimal ? 100 : 10;
  return (num * factor).roundToDouble() / factor;
}

String testBlank(String str) {
  if (str == null || str.isEmpty) {
    return Strings.get("unknown");
  } else {
    return str;
  }
}

bool isZeroOrNull(num n) {
  return n == 0 || n == null;
}

String unGzip(Uint8List bytes) {
  return Utf8Decoder().convert(GZipDecoder().decodeBytes(bytes));
}

double getBottomPadding(BuildContext context) {
  var query = MediaQuery.of(context);
  return query.padding.bottom + query.viewInsets.bottom;
}

Brightness currentBrightness = Brightness.light;

void updateNavigationBarBrightness({BuildContext context}) {
  if (isLightMode(context: context)) {
    FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  } else {
    FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }
}

bool isLightMode({BuildContext context}) {
  if (context != null) {
    currentBrightness = MediaQuery
        .of(context)
        .platformBrightness ?? currentBrightness;
  }
  switch (Config.darkMode) {
    case 0:
      return true;
    case 1:
      return currentBrightness == Brightness.light;
    case 2:
      return false;
  }
}

SystemUiOverlayStyle getSystemUiOverlayStyle(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}

bool isSameDay(DateTime d1, DateTime d2) {
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

bool isAndroid() {
  return Platform.isAndroid;
}

double powWithSign(double a, double b) {
  return pow(a, b) * ((a < 0) ? -1 : 1);
}

double cap(double number, double min, double max) {
  if (number > max) {
    return max;
  } else if (number < min) {
    return min;
  } else {
    return number;
  }
}

MaterialColor getPrimary() {
  return Config.primaryColor;
}
