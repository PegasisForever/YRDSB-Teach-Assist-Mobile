import 'package:flutter/material.dart';
import 'package:ta/model/CalendarModels.dart';
import 'package:ta/pages/calendarpage/Calendar.dart';
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
