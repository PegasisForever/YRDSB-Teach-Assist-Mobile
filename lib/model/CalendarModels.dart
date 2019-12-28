import 'dart:convert';

import 'package:ta/dataStore.dart';
import 'package:ta/tools.dart';

class Event {
  Map<String, String> name = {};

  DateTime startDate;
  DateTime endDate;
}

List<Event> readCalendar() {
  var str = prefs.getString("calendar");
  var list = <Event>[];
  jsonDecode(str).forEach((obj) {
    var event = Event();
    obj["name"].forEach((language, name) {
      event.name[language] = name;
    });
    event.startDate = str2Date(obj["start_date"]);
    event.endDate = obj["end_date"] == null
        ? null
        : str2Date(obj["end_date"]).add(Duration(hours: 23, minutes: 59));
    list.add(event);
  });

  return list;
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
