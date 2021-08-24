import 'dart:convert';

import 'package:ta/plugins/dataStore.dart';
import 'package:ta/tools.dart';

class Event {
  Map<String, String> name = {};

  DateTime startDate;
  DateTime endDate;

  static Event fromJson(dynamic json) {
    var event = Event();
    json["name"].forEach((language, name) {
      event.name[language] = name;
    });
    event.startDate = str2Date(json["start_date"]);
    event.endDate = json["end_date"] == null
        ? null
        : str2Date(json["end_date"]).add(Duration(hours: 23, minutes: 59));
    return event;
  }
}

List<Event> readCalendar(String name) {
  var str = prefs.getString("calendar_v2");
  if (str == null) return [];

  var json = jsonDecode(str);
  var calendar = (json["calendar_common"] as List<dynamic>)
      .map((e) => Event.fromJson(e))
      .toList(growable: true);
  try {
    var calendarDiff =
        (json["calendar_difference"][name]["events"] as List<dynamic>)
            .map((e) => Event.fromJson(e));
    calendar.addAll(calendarDiff);
  } catch (e) {}

  return calendar;
}

Map<String, Map<String, String>> readCalendarDiffs() {
  var str = prefs.getString("calendar_v2");
  if (str == null) return {};

  var json = jsonDecode(str);
  var diffsJson = json["calendar_difference"] as Map<String, dynamic>;
  return diffsJson.map((diffName, diffJson) =>
      MapEntry(diffName, diffJson["name"].cast<String, String>()));
}

extension CalenderList on List<Event> {
  List<Event> findEvents(DateTime date) {
    var list = <Event>[];
    this.forEach((event) {
      if (event.endDate == null) {
        if (isSameDay(date, event.startDate)) {
          list.add(event);
        }
      } else {
        if (date.isAfter(event.startDate) && date.isBefore(event.endDate)) {
          list.add(event);
        }
      }
    });
    return list;
  }
}

const HolidayIconMap = {
  "Labour Day": "labour_day",
  "PA Day": "pa_day",
  "Thanksgiving Day": "thanksgiving_day",
  "Winter Break": "winter_break",
  "Family Day": "family_day",
  "Mid-Winter Break": "winter_break",
  "Good Friday": "good_friday",
  "Easter Monday": "easter_monday",
  "Victoria Day": "victoria_day",
};

enum DateType { NORMAL, OUTLINE, FILL }

const WEEKDAYS = [
  "monday",
  "tuesday",
  "wednesday",
  "thursday",
  "friday",
  "saturday",
  "sunday",
];
const MONTHS = [
  "january",
  "february",
  "march",
  "april",
  "may",
  "june",
  "july",
  "august",
  "september",
  "october",
  "november",
  "december",
];
