import 'dart:convert';
import 'dart:io';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/plugins/packageinfo.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

const String baseUrl = (kReleaseMode || kProfileMode )
    ? "https://api.pegasis.site/yrdsb_ta/"
    : "http://192.168.1.81:5004/";
const int apiVersion = 11;

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
  var res = await _postWithMetric(
      baseUrl + "regi",
      jsonEncode(
          {"user": user, "token": Config.firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> deregi(User user) async {
  var res = await _postWithMetric(
      baseUrl + "deregi",
      jsonEncode(
          {"user": user, "token": Config.firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return;
}

Future<String> getMarkTimeLine(User user) async {
  var res = await _postWithMetric(
      baseUrl + "getmark_timeline",
      jsonEncode(
          {"user": user, "token": Config.firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> updateNoFetch(User user) async {
  var res = await _postWithMetric(
      baseUrl + "update_nofetch",
      jsonEncode(
          {"user": user, "token": Config.firebaseToken, "language": Strings.currentLanguage}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> getArchived(User user) async {
  var res = await _postWithMetric(
      baseUrl + "getarchived", jsonEncode({"number": user.number, "password": user.password}));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> sendFeedBack(String contactInfo, String feedback) async {
  var res = await _postWithMetric(
      baseUrl + "feedback",
      jsonEncode({
        "contact_info": contactInfo,
        "feedback": feedback,
        "platform": isAndroid() ? "Android" : "iOS",
        "version": packageInfo.version + " " + packageInfo.buildNumber,
      }));

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }
}

Future<String> getCalendar() async {
  var res = await _postWithMetric(baseUrl + "getcalendar", {});

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> getAnnouncement() async {
  var res = await _postWithMetric(baseUrl + "getannouncement", {});

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

getAndSaveMarkTimeline(User user, {bool noFetch = false}) async {
  String res;
  if (noFetch) {
    res = await updateNoFetch(user);
  } else {
    res = await getMarkTimeLine(user);
  }
  var json = jsonDecode(res) as Map<String, dynamic>;

  saveCourseListOf(user.number, json["course_list"],
      time: json.containsKey("update_time") ? DateTime.parse(json["update_time"]) : null);
  saveTimelineOf(user.number, json["time_line"]);
}

getAndSaveArchived(User user) async {
  var res = await getArchived(user);
  var json = jsonDecode(res);

  saveArchivedCourseListOf(user.number, json);
}

regiAndSave(User user) async {
  var res = await regi(user);
  var json = jsonDecode(res);

  saveCourseListOf(user.number, json["course_list"]);
  saveTimelineOf(user.number, json["time_line"]);
}

getAndSaveCalendar() async {
  var lastCalendarUpdateTime = prefs.getString("last_update_calendar");
  if (lastCalendarUpdateTime != null &&
      DateTime.now().difference(DateTime.parse(lastCalendarUpdateTime)).inHours < 2) {
    return;
  }

  var res = await getCalendar();
  prefs.setString("last_update_calendar", DateTime.now().toString());
  prefs.setString("calendar", res);
}

getAndSaveAnnouncement() async {
  var lastAnnouncementUpdateTime = prefs.getString("last_update_announcement");
  if (lastAnnouncementUpdateTime != null &&
      DateTime.now().difference(DateTime.parse(lastAnnouncementUpdateTime)).inMinutes < 2) {
    return;
  }

  var res = await getAnnouncement();
  prefs.setString("last_update_announcement", DateTime.now().toString());
  prefs.setString("announcement", res);
}
