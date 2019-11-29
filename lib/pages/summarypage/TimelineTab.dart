import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/timelinecontents/getUpdateWidget.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> with AutomaticKeepAliveClientMixin {
  List<TAUpdate> timeline;
  Map<String, WeightTable> weightTableMap;
  String userNumber;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userNumber != currentUser.number) {
      userNumber = currentUser.number;
      timeline = getTimelineOf(currentUser.number);
      var courses = getCourseListOf(userNumber);
      weightTableMap = Map();
      courses.forEach((course) {
        weightTableMap[course.displayName] = course.weightTable;
      });
    }

    return timeline.length > 0
        ? ListView(
      padding: EdgeInsets.only(bottom: 8 + getBottomPadding(context)),
      children: _getTimelineCards(timeline),
    )
        : Center(
      child: Text(
        Strings.get("timeline_blank_text"),
        style: Theme
            .of(context)
            .textTheme
            .subhead,
      ),
    );
  }

  List<Widget> _getTimelineCards(List<TAUpdate> timeline) {
    var list = List<Widget>();
    var sameDayContents = List<Widget>();
    DateTime lastContentDate;

    timeline.reversed.forEach((update) {
      if (sameDayContents.length == 0) {
        sameDayContents.add(getUpdateWidget(update, weightTableMap));
        lastContentDate = update.time;
      } else if (isSameDay(lastContentDate, update.time)) {
        sameDayContents.add(getUpdateWidget(update, weightTableMap));
      } else {
        sameDayContents.removeWhere((item) => item == null);
        list.add(_cardOfDate(time: lastContentDate, children: sameDayContents));
        sameDayContents = List<Widget>();
        sameDayContents.add(getUpdateWidget(update, weightTableMap));
        lastContentDate = update.time;
      }
    });
    if (sameDayContents.length != 0) {
      sameDayContents.removeWhere((item) => item == null);
      list.add(_cardOfDate(time: lastContentDate, children: sameDayContents));
    }

    return list;
  }

  Widget _cardOfDate({List<Widget> children, DateTime time}) {
    var contents = List<Widget>();
    for (var i = 0; i < children.length; i++) {
      var widget = children[i];
      contents.add(widget);
      if (i != children.length - 1) {
        contents.add(Divider());
        contents.add(SizedBox(
          height: 4,
        ));
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(DateFormat("EEE, MMM d").format(time),
                style: Theme.of(context).textTheme.title),
          ),
          SizedBox(
            height: 4,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: contents,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
