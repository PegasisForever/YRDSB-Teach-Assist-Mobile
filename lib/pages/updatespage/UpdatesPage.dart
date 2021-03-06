import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/updatespage/updatecontents/getUpdateWidget.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class UpdatesPage extends StatefulWidget {
  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends BetterState<UpdatesPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var sidePadding = (getScreenWidth(context) - 500) / 2;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(Strings.get("updates")),
              floating: true,
              snap: true,
              textTheme: Theme.of(context).textTheme,
              iconTheme: Theme.of(context).iconTheme,
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                left: max(sidePadding, 0),
                right: max(sidePadding, 0),
                bottom: getBottomPadding(context),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  _getTimelineCards(getTimelineOf(currentUser.number)),
                ),
              ),
            )
          ],
        ));
  }

  List<Widget> _getTimelineCards(List<TAUpdate> timeline) {
    var list = List<Widget>();
    var sameDayContents = List<Widget>();
    DateTime lastContentDate;

    timeline.reversed.forEach((update) {
      if (sameDayContents.length == 0) {
        addIfNotNull(sameDayContents, getUpdateWidget(update));
        lastContentDate = update.time;
      } else if (isSameDay(lastContentDate, update.time)) {
        addIfNotNull(sameDayContents, getUpdateWidget(update));
      } else {
        list.add(_cardOfDate(time: lastContentDate, children: sameDayContents));
        sameDayContents = List<Widget>();
        addIfNotNull(sameDayContents, getUpdateWidget(update));
        lastContentDate = update.time;
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
      contents.add(children[i]);
      if (i != children.length - 1) {
        contents.add(SizedBox(height: 4));
        contents.add(Divider());
        contents.add(SizedBox(height: 4));
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 14, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(DateFormat("EEE, MMM d").format(time), style: Theme.of(context).textTheme.title),
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
