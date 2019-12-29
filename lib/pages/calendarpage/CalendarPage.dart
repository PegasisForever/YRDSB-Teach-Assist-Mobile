import 'package:flutter/material.dart';
import 'package:ta/model/CalendarModels.dart';
import 'package:ta/pages/calendarpage/Calendar.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends BetterState<CalendarPage> {
  bool showReturnButton = false;
  var calendarKey = GlobalKey<CalendarState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var today = DateTime.now();
    List<Event> calendar = readCalendar();
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("calendar")),
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          if (showReturnButton)
            IconButton(
              icon: Icon(Icons.reply),
              onPressed: () {
                calendarKey.currentState.jumpToDate(DateTime(today.year, today.month));
              },
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Calendar(
            key: calendarKey,
            startMonth: DateTime(today.year, today.month),
            getEventWidgets: (context, time) {
              var events = Set<Event>();
              for (var date = DateTime(time.year, time.month);
                  date.month == time.month;
                  date = date.add(Duration(days: 1))) {
                var eventInThisDay = calendar.findEvents(date);
                if (eventInThisDay.length > 0) {
                  events.addAll(eventInThisDay);
                }
              }

              var widgets = <Widget>[];
              events.forEach((event) {
                widgets.add(CalendarEvent(
                  leading: getHolidayIcon(event.name["en"], context),
                  name: event.name[Strings.currentLanguage],
                  startDate: event.startDate,
                  endDate: event.endDate,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ));
              });

              return widgets;
            },
            onMonthChanged: (time) {
              setState(() {
                showReturnButton = !(today.year == time.year && today.month == time.month);
              });
            },
            builder: (context, date) {
              var dateType = DateType.NORMAL;
              var eventInThisDay = calendar.findEvents(date.add(Duration(hours: 1)));
              if (eventInThisDay.length > 0) {
                dateType = DateType.OUTLINE;
              }
              if (isSameDay(date, today)) {
                dateType = DateType.FILL;
              }
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: dateType == DateType.FILL ? getPrimary() : null,
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
                    date.day.toString(),
                    style: TextStyle(
                      color: dateType == DateType.FILL ? getGrey(-400, context: context) : null,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
            indicatorBuilder: (context, weekDay) {
              return Container(
                width: 40,
                height: 20,
                child: Center(
                  child: Text(
                    Strings.get(weekDay + "_short"),
                    style: TextStyle(fontSize: 12, color: getGrey(200, context: context)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
