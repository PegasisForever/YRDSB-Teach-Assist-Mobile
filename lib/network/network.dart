import 'dart:convert';
import 'dart:io';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

import '../firebase.dart';

const String baseUrl = kReleaseMode
    ? "https://api.pegasis.site/yrdsb_ta/"
    : "http://192.168.1.22:5004/";
const int apiVersion = 4;

class HttpResponse {
  String body = "";
  int statusCode;
}

Future<HttpResponse> _postWithMetric(String url, body) async {
  final metric = FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Post);

  await metric.start();

  var res = HttpResponse();
  try {
    Response response =
        await post(url, headers: {"api-version": apiVersion.toString()}, body: body);

    res.statusCode = response.statusCode;
    if (res.statusCode == 200 && response.body != "") {
      res.body = unGzip(response.bodyBytes);
    }

    metric
      ..responsePayloadSize = response.contentLength
      ..httpResponseCode = response.statusCode;
  } finally {
    await metric.stop();
  }

  return res;
}

Future<String> regi(User user) async {
  var res = await _postWithMetric(baseUrl + "regi",
      jsonEncode({"user": user, "token": firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> deregi(User user) async {
  var res = await _postWithMetric(baseUrl + "deregi",
      jsonEncode({"user": user, "token": firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return;
}

Future<String> getMarkTimeLine(User user) async {
  var res = await _postWithMetric(
      baseUrl + "getmark_timeline", jsonEncode({"number": user.number, "password": user.password}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> sendFeedBack(String contactInfo, String feedback) async {
  var res = await _postWithMetric(
      baseUrl + "feedback", jsonEncode({"contact_info": contactInfo, "feedback": feedback}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }
}

getAndSaveMarkTimeline(User user) async {
  var res = await getMarkTimeLine(user);
  var json = jsonDecode(res);

  saveCourseListOf(user.number, json["course_list"]);
  saveTimelineOf(user.number, json["time_line"]);
}

regiAndSave(User user) async {
  var res = await regi(user);
  var json = jsonDecode(res);

  saveCourseListOf(user.number, json["course_list"]);
  saveTimelineOf(user.number, json["time_line"]);
}
