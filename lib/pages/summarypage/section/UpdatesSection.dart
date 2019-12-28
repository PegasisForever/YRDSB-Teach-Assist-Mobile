import 'package:flutter/material.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/pages/updatespage/updatecontents/getUpdateWidget.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class UpdatesSection extends SectionCandidate {
  final timeline = List<TAUpdate>();

  @override
  _UpdatesSectionState createState() => _UpdatesSectionState();

  @override
  bool shouldDisplay() {
    timeline.clear();
    timeline.addAll(getTimelineOf(currentUser.number));

    if (timeline.length == 0) {
      return false;
    } else if (timeline.last.time.difference(DateTime.now()).inDays > 5) {
      return false;
    } else {
      return true;
    }
  }
}

class _UpdatesSectionState extends State<UpdatesSection> {
  @override
  Widget build(BuildContext context) {
    var cardWidgets = List<Widget>();
    DateTime lastContentDate;
    for (final TAUpdate update in widget.timeline.reversed) {
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

    return Section(
      title: Strings.get("recent_updates"),
      buttonText: Strings.get("view_all"),
      onTap: () {
        Navigator.pushNamed(context, "/updates");
      },
      card: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: cardWidgets,
          ),
        ),
      ),
    );
  }
}
