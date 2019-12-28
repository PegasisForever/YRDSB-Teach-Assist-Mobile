import 'package:flutter/material.dart';
import 'package:ta/model/Calendar.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

import 'Section.dart';

class CalendarSection extends SectionCandidate {
  final calendar = List<Event>();

  @override
  _CalendarSectionState createState() => _CalendarSectionState();

  @override
  bool shouldDisplay() {
    calendar.clear();
    calendar.addAll(readCalendar());

    var today = DateTime.now();
    var days = [for (int i = 0; i < 5; i++) today.add(Duration(days: i))];
    for (final day in days) {
      if (calendar.findEvents(day).length > 0) {
        return true;
      }
    }

    return false;
  }
}

class _CalendarSectionState extends State<CalendarSection> {
  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    var days = [for (int i = 0; i < 5; i++) today.add(Duration(days: i))];
    var events = Set<Event>();
    return Section(
      title: Strings.get("events"),
      buttonText: Strings.get("view_full_calendar"),
      onTap: () {
        Navigator.pushNamed(context, "/calendar");
      },
      card: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days.map((date) {
                  var dateType = DateType.NORMAL;
                  var eventsInThisDay = widget.calendar.findEvents(date);
                  if (eventsInThisDay.length > 0) {
                    dateType = DateType.OUTLINE;
                    events.addAll(eventsInThisDay);
                  }
                  if (date.day == today.day) {
                    dateType = DateType.FILL;
                  }
                  return _CalenderDate(
                    dateType: dateType,
                    date: date.day,
                    title: Strings.get(WEEKDAYS[date.weekday - 1] + "_short"),
                  );
                }).toList(),
              ),
              for (final event in events)
                CalendarEvent(
                  leading: getHolidayIcon(event.name["en"], context),
                  name: event.name[Strings.currentLanguage],
                  startDate: event.startDate,
                  endDate: event.endDate,
                  padding: const EdgeInsets.only(top: 16),
                ),
            ],
          ),
        ),
      ),
    );
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

Widget getHolidayIcon(String name, BuildContext context) {
  if (HolidayIconMap.containsKey(name)) {
    return Image.asset(
      isLightMode(context: context)
          ? "assets/images/${HolidayIconMap[name]}.png"
          : "assets/images/${HolidayIconMap[name]}_ondark.png",
      height: 28,
      width: 28,
    );
  } else if (name == "First Day of Classes" || name == "Last Day of Classes") {
    return Icon(
      Icons.business,
      size: 28,
    );
  } else {
    return Icon(
      Icons.calendar_today,
      size: 28,
    );
  }
}

class CalendarEvent extends StatelessWidget {
  final Widget leading;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final EdgeInsets padding;

  CalendarEvent({this.leading, this.name, this.startDate, this.endDate, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: leading,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            flex: 0,
            child: Text(
              name,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Text(
              endDate == null ? date2Str(startDate) : period2Str(startDate, endDate),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}

enum DateType { NORMAL, OUTLINE, FILL }

const WEEKDAYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
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
  "december"
];

class _CalenderDate extends StatelessWidget {
  final DateType dateType;
  final String title;
  final int date;

  _CalenderDate({this.dateType, this.title, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 12, color: getGrey(200, context: context)),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: dateType == DateType.FILL ? getPrimary() : Colors.grey.withAlpha(40),
            shape: BoxShape.circle,
            border: dateType == DateType.OUTLINE
                ? Border.all(
                    color: getPrimary(),
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              date.toString(),
              style: TextStyle(
                color: dateType == DateType.FILL ? getGrey(-400, context: context) : null,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}
