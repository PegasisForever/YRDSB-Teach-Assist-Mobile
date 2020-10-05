import 'package:flutter/material.dart';
import 'package:ta/model/CalendarModels.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

typedef Widget CalendarDateBuilder(BuildContext context, DateTime date);
typedef Widget CalendarIndicatorBuilder(BuildContext context, String weekDay);
typedef DateTimeCallBack(DateTime time);
typedef List<Widget> GetEventWidgets(BuildContext context, DateTime date);

class Calendar extends StatefulWidget {
  final DateTime startMonth;
  final CalendarDateBuilder builder;
  final CalendarIndicatorBuilder indicatorBuilder;
  final DateTimeCallBack onMonthChanged;
  final GetEventWidgets getEventWidgets;

  Calendar(
      {this.startMonth,
      this.builder,
      this.indicatorBuilder,
      this.onMonthChanged,
      this.getEventWidgets,
      Key key})
      : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  PageController pageController;
  DateTime currentMonth;

  int date2Index(DateTime date) {
    return (date.year - 2019) * 12 + date.month - 1;
  }

  jumpToDate(DateTime date) {
    setState(() {
      currentMonth = DateTime(date.year, date.month);
      pageController.animateToPage(
        date2Index(currentMonth),
        curve: Curves.easeInOutCubic,
        duration: Duration(milliseconds: 200),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: date2Index(widget.startMonth));
    currentMonth = widget.startMonth;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          flex: 0,
          child: CalendarHeader(
            text: Strings.getLocalizedMonth(currentMonth),
            onBack: (currentMonth.year == 2019 && currentMonth.month == 1)
                ? null
                : () => jumpToDate(
                    DateTime(currentMonth.year, currentMonth.month - 1)),
            onNext: (currentMonth.year == 2023 && currentMonth.month == 12)
                ? null
                : () => jumpToDate(
                    DateTime(currentMonth.year, currentMonth.month + 1)),
          ),
        ),
        Expanded(
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentMonth =
                    DateTime((index / 12).floor() + 2019, index % 12 + 1);
                widget.onMonthChanged(currentMonth);
              });
            },
            controller: pageController,
            itemCount: 5 * 12, //2019/1 - 2023/12
            itemBuilder: (context, index) {
              var timeInPageView =
                  DateTime((index / 12).floor() + 2019, index % 12 + 1);
              return ListView(
                children: [
                  CalendarWeekDayIndicator(
                    indicatorBuilder: widget.indicatorBuilder,
                  ),
                  CalendarMonth(
                    startMonth: timeInPageView,
                    builder: widget.builder,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ...widget.getEventWidgets(context, timeInPageView)
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget getHolidayIcon(String name, BuildContext context) {
  if (HolidayIconMap.containsKey(name)) {
    return Image.asset(
      isLightMode(context: context)
          ? "assets/icons/${HolidayIconMap[name]}.png"
          : "assets/icons/${HolidayIconMap[name]}_ondark.png",
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

  CalendarEvent(
      {this.leading, this.name, this.startDate, this.endDate, this.padding});

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
              endDate == null
                  ? date2Str(startDate)
                  : period2Str(startDate, endDate),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final String text;
  final VoidCallback onBack;
  final VoidCallback onNext;

  CalendarHeader({this.text, this.onBack, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                iconSize: 18,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: onBack,
              ),
              IconButton(
                iconSize: 18,
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: onNext,
              )
            ],
          )
        ],
      ),
    );
  }
}

class CalendarWeekDayIndicator extends StatelessWidget {
  final CalendarIndicatorBuilder indicatorBuilder;

  CalendarWeekDayIndicator({this.indicatorBuilder});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (final weekDay in WEEKDAYS) indicatorBuilder(context, weekDay)
      ],
    );
  }
}

class CalendarMonth extends StatelessWidget {
  final DateTime startMonth;
  final CalendarDateBuilder builder;

  CalendarMonth({this.startMonth, this.builder});

  // fix day light saving times
  DateTime round2NearestDay(DateTime date) {
    if (date.hour == 0) {
      return date;
    } else if (date.hour < 12) {
      return date.subtract(Duration(hours: date.hour));
    } else {
      return date.add(Duration(hours: 24 - date.hour));
    }
  }

  @override
  Widget build(BuildContext context) {
    var calendarRows = <Widget>[];
    for (var startDate = round2NearestDay(
            startMonth.subtract(Duration(days: startMonth.weekday - 1)));
        startDate.year * 12 + startDate.month <=
            startMonth.year * 12 + startMonth.month;
        startDate = round2NearestDay(startDate.add(Duration(days: 7)))) {
      calendarRows.add(CalendarRow(
        startDate: startDate,
        builder: builder,
        month: startMonth.month,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: calendarRows,
    );
  }
}

class CalendarRow extends StatelessWidget {
  final int month;
  final DateTime startDate;
  final CalendarDateBuilder builder;

  CalendarRow({this.startDate, this.builder, this.month});

  @override
  Widget build(BuildContext context) {
    var dates = [for (int i = 0; i < 7; i++) startDate.add(Duration(days: i))];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (final date in dates)
            date.month == month
                ? builder(context, date)
                : Opacity(
                    opacity: 0.4,
                    child: builder(context, date),
                  )
        ],
      ),
    );
  }
}
