import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/timelinecontents/getUpdateWidget.dart';
import 'package:ta/tools.dart';

class UpdatesCard extends StatelessWidget {
  final List<TAUpdate> timeline = getTimelineOf(currentUser.number);

  @override
  Widget build(BuildContext context) {
    var cardWidgets = List<Widget>();
    DateTime lastContentDate;
    for (final TAUpdate update in timeline.reversed) {
      if (cardWidgets.length < 2 &&
          (lastContentDate == null || isSameDay(lastContentDate, update.time))) {
        addIfNotNull(cardWidgets, getUpdateWidget(update));
        lastContentDate = update.time;
      } else {
        break;
      }
    }

    if (cardWidgets.length == 2)
      cardWidgets.insert(
        1,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Divider(),
        ),
      );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: cardWidgets,
        ),
      ),
    );
  }
}
