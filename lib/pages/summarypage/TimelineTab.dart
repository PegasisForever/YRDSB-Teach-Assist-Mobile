import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> with AutomaticKeepAliveClientMixin {
  List<TAUpdate> timeline;
  String userNumber;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userNumber != currentUser.number) {
      userNumber = currentUser.number;
      timeline = getTimelineOf(currentUser.number);
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
      if (update is AssignmentAdded) {
        if (sameDayContents.length == 0) {
          sameDayContents.add(_contentFromAssignmentAdded(update));
          lastContentDate = update.time;
        } else if (isSameDay(lastContentDate, update.time)) {
          sameDayContents.add(_contentFromAssignmentAdded(update));
        } else {
          list.add(_cardOfDate(time: lastContentDate, children: sameDayContents));
          sameDayContents = List<Widget>();
          sameDayContents.add(_contentFromAssignmentAdded(update));
          lastContentDate = update.time;
        }
      }
    });
    if (sameDayContents.length != 0) {
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

  Widget _contentFromAssignmentAdded(AssignmentAdded update) {
    return Column(
      key: Key(update.hashCode.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.note_add,
              size: 32,
              color: Colors.green,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(update.courseName),
                  Text(update.assignment.name, style: Theme.of(context).textTheme.title),
                ],
              ),
            )
          ],
        ),
        update.overallBefore != null
            ? Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    num2Str(update.overallBefore) + "%",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward, size: 32),
                  Text(num2Str(update.overallAfter) + "%",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              update.overallBefore > update.overallAfter
                  ? LPI.LinearProgressIndicator(
                lineHeight: 20.0,
                value1: update.overallAfter / 100,
                value2: update.overallBefore / 100,
                value1Color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                value2Color: Colors.red[400],
              )
                  : LPI.LinearProgressIndicator(
                lineHeight: 20.0,
                value1: update.overallBefore / 100,
                value2: update.overallAfter / 100,
                value1Color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                value2Color: Colors.green,
              ),
            ],
          ),
        )
            : SizedBox(width: 0, height: 0)
      ],
    );
  }
}
