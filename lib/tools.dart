import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:quiver/core.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';

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

bool isBlank(String str) {
  return str == null || str.isEmpty;
}

bool isZeroOrNull(num n) {
  return n == 0 || n == null;
}

String unGzip(Uint8List bytes) {
  return Utf8Decoder().convert(GZipDecoder().decodeBytes(bytes));
}

double getTopPadding(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double getBottomPadding(BuildContext context) {
  var query = MediaQuery.of(context);
  return query.padding.bottom + query.viewInsets.bottom;
}

Brightness currentBrightness = Brightness.light;

bool editorDialogOpened = false;

void updateNavigationBarBrightness({BuildContext context}) {
  if (isLightMode(context: context)) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(editorDialogOpened);
    FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFFAFAFA),
        animate: true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  } else {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF303030),
        animate: false);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }
}

bool isLightMode({BuildContext context}) {
  if (context != null) {
    currentBrightness =
        MediaQuery.of(context).platformBrightness ?? currentBrightness;
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
  return brightness == Brightness.light
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
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

addIfNotNull(List list, dynamic item) {
  if (item != null) {
    list.add(item);
  }
}

Color primaryColorOf(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

T find<T>(List<T> list, bool f(T it)) {
  for (var item in list) {
    if (f(item)) {
      return item;
    }
  }
  return null;
}

double sum<T>(List<T> list, double f(T it)) {
  var total = 0.0;
  list.forEach((item) {
    total += f(item);
  });
  return total;
}

Color getGrey(int contrast, {BuildContext context}) {
  return isLightMode(context: context)
      ? Colors.grey[500 + contrast]
      : Colors.grey[500 - contrast];
}

String period2Str(DateTime date1, DateTime date2) {
  if (date1.year == date2.year) {
    return date2Str(date1) + " - " + date2Str(date2);
  } else {
    return date2Str(date1, keepYear: true) +
        " - " +
        date2Str(date2, keepYear: true);
  }
}

String date2Str(DateTime date, {bool keepYear = false}) {
  if (keepYear) {
    return "${date.year}/${date.month}/${date.day}";
  } else {
    return "${date.month}/${date.day}";
  }
}

// example input: 2019-5-20
DateTime str2Date(String str) {
  var numberList = str.split("-");
  return DateTime(
      numberList[0].toInt(), numberList[1].toInt(), numberList[2].toInt());
}

extension on String {
  int toInt() {
    return int.parse(this);
  }
}

double getScreenHeight(BuildContext context) {
  var query = MediaQuery.of(context);
  return query.size.height - query.padding.top - query.padding.bottom;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

enum Direction {
  UP,
  DOWN,
}

typedef TwoValueChanged<T, R> = void Function(T value, R value2);

Future asyncWait(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}

int hashNullableObjects(Iterable objects) {
  if (objects == null) {
    return null.hashCode;
  } else {
    return hashObjects(objects);
  }
}

bool listsEqual(List list1, List list2) {
  if (list1.length != list2.length) return false;

  for (var i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }

  return true;
}
