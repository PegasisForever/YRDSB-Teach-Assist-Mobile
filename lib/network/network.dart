import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

import '../firebaseMsg.dart';

const String baseUrl = kReleaseMode
    ? "https://api.pegasis.site/yrdsb_ta/"
    : "http://192.168.1.22:5004/";
const int apiVersion = 2;

Future<String> regi(User user) async {
  print(baseUrl);
  Response response = await post(baseUrl + "regi",
      headers: {"api-version": apiVersion.toString()},
      body: jsonEncode({"user": user, "token": firebaseToken,"language":Strings.currentLanguage}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return unGzip(response.bodyBytes);
}

Future<void> deregi(User user) async {
  Response response = await post(baseUrl + "deregi",
      headers: {"api-version": apiVersion.toString()},
      body: jsonEncode({"user": user, "token": firebaseToken}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return;
}

Future<String> getMarkTimeLine(User user) async {
  Response response = await post(baseUrl + "getmark_timeline",
      headers: {"api-version": apiVersion.toString()},
      body: jsonEncode({"number": user.number, "password": user.password}));

  int statusCode = response.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return unGzip(response.bodyBytes);
}

Future<String> getAndSaveMarkTimeline(User user) async {
  var strs=(await getMarkTimeLine(currentUser)).split("|||");
  var markStr=strs[0];
  var timelineStr=strs[1];

  saveCourseListOf(user.number, markStr);
  saveTimelineOf(user.number, timelineStr);
  print(timelineStr);
}
