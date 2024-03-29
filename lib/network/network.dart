import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart' as convert;
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:ta/log.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/plugins/packageinfo.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

part 'gdns.dart';

Uri baseUri = (kReleaseMode || kProfileMode)
    ? Uri.https("api.pegasis.site", "/yrdsb_ta/")
    : Uri.http("192.168.0.81:5004", "/");

const int apiVersion = 13;

class HttpResponse {
  String body = "";
  int statusCode;
}

Client _client;

Client _getClient() {
  if (_client == null)
    _client = IOClient(
      HttpClient()
        ..badCertificateCallback =
            (cert, host, _) => _gdnsValidateCert(cert, host),
    );
  return _client;
}

bool _fallback = false;

Future<HttpResponse> _post(Uri uri, body) async {
  Response response = await _getClient().post(
    uri,
    headers: {"api-version": apiVersion.toString()},
    body: body,
  );

  var res = HttpResponse();
  res.statusCode = response.statusCode;
  if (res.statusCode == 200 && response.body != "") {
    res.body = unGzip(response.bodyBytes);
  }

  return res;
}

Future<HttpResponse> _fallbackPost(Uri uri, body) async {
  log("Using GDNS to resolve $uri");
  final resolvedUri = await _gdnsResolve(uri);
  log("$uri resolved: $resolvedUri, sending post request");
  final res = await _post(resolvedUri, body);
  _fallback = true;
  log("Setting fallback to true");
  return res;
}

Future<HttpResponse> _postWithMetric(String path, body) async {
  final uri = baseUri.replace(path: baseUri.path + path);
  final metric = FirebasePerformance.instance
      .newHttpMetric(uri.toString(), HttpMethod.Post);

  await metric.start();

  var res = HttpResponse();

  if (!_fallback) {
    try {
      log("Sending post request to $uri");
      res = await _post(uri, body);
      log("Successfully posted $uri");
    } catch (e, t) {
      logError("Post failed: $e",trace: t);
      // fallback
      if (_isDomain(uri)) {
        log("Trying fallback method");
        try {
          res = await _fallbackPost(uri, body);
        } catch (e, t) {
          logError("Fallback method failed: $e",trace: t);
        }
      } else {
        log("Not trying fallback method: not a domain");
      }
    }
  } else {
    log("fallback=true, using fallback method");
    try {
      res = await _fallbackPost(uri, body);
    } catch (e, t) {
      logError("Fallback method failed: $e",trace: t);
    }
  }

  if (res.statusCode != null) {
    metric.httpResponseCode = res.statusCode;
    log("Post to $uri successed, got status code: ${res.statusCode}");
  } else {
    logError("Post to $uri failed.");
  }
  await metric.stop();

  return res;
}

Future<String> regi(User user) async {
  var res = await _postWithMetric(
    "regi",
    jsonEncode({
      "user": user,
      "token": Config.firebaseToken,
      "language": Strings.currentLanguage,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> deregi(User user) async {
  var res = await _postWithMetric(
    "deregi",
    jsonEncode({
      "user": user,
      "token": Config.firebaseToken,
      "language": Strings.currentLanguage,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return;
}

Future<String> getMarkTimeLine(User user) async {
  var res = await _postWithMetric(
    "getmark_timeline",
    jsonEncode({
      "user": user,
      "token": Config.firebaseToken,
      "language": Strings.currentLanguage,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> updateNoFetch(User user) async {
  var res = await _postWithMetric(
    "update_nofetch",
    jsonEncode({
      "user": user,
      "token": Config.firebaseToken,
      "language": Strings.currentLanguage,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> getArchived(User user) async {
  var res = await _postWithMetric(
    "getarchived",
    jsonEncode({
      "number": user.number,
      "password": user.password,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<void> sendFeedBack(String contactInfo, String feedback) async {
  var res = await _postWithMetric(
    "feedback",
    jsonEncode({
      "contact_info": contactInfo,
      "feedback": feedback,
      "platform": isAndroid() ? "Android" : "iOS",
      "version": packageInfo.version + " " + packageInfo.buildNumber,
    }),
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }
}

Future<String> getCalendar() async {
  var res = await _postWithMetric(
    "getcalendar",
    {},
  );

  int statusCode = res.statusCode;
  if (statusCode != 200) {
    throw HttpException(statusCode.toString());
  }

  return res.body;
}

Future<String> getAnnouncement() async {
  var res = await _postWithMetric(
    "getannouncement",
    {},
  );

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
      time: json.containsKey("update_time")
          ? DateTime.parse(json["update_time"])
          : null);
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
  var lastCalendarUpdateTime = prefs.getString("last_update_calendar_v2");
  if (lastCalendarUpdateTime != null &&
      DateTime.now()
              .difference(DateTime.parse(lastCalendarUpdateTime))
              .inHours <
          2) {
    return;
  }

  var res = await getCalendar();
  prefs.setString("last_update_calendar_v2", DateTime.now().toString());
  prefs.setString("calendar_v2", res);
}

getAndSaveAnnouncement() async {
  var lastAnnouncementUpdateTime = prefs.getString("last_update_announcement");
  if (lastAnnouncementUpdateTime != null &&
      DateTime.now()
              .difference(DateTime.parse(lastAnnouncementUpdateTime))
              .inMinutes <
          2) {
    return;
  }

  var res = await getAnnouncement();
  prefs.setString("last_update_announcement", DateTime.now().toString());
  prefs.setString("announcement", res);
}
