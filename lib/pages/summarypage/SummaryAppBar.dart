import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class SummaryPageAppBar extends StatefulWidget {
  final Function onOpenDrawer;
  final bool hasActiveCourses;
  final bool isAutoRefreshing;

  const SummaryPageAppBar({Key key, this.onOpenDrawer, this.hasActiveCourses, this.isAutoRefreshing}) : super(key: key);

  @override
  _SummaryPageAppBarState createState() => _SummaryPageAppBarState();
}

class _SummaryPageAppBarState extends State<SummaryPageAppBar> with WidgetsBindingObserver {
  Timer timer;

  startTimer() {
    timer?.cancel();
    timer = Timer.periodic(new Duration(seconds: 2), (timer) {
      setState(() {}); //update "updateText"
    });
  }

  stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  String getUpdateText() {
    var lastUpdateStr = prefs.getString("last_update-${currentUser.number}");
    var updateText = "";
    if (lastUpdateStr != null) {
      var lastUpdateTime = DateTime.parse(lastUpdateStr);
      var timePassed = DateTime.now().difference(lastUpdateTime);

      if (timePassed.inSeconds < 60) {
        updateText = Strings.get("just_updated");
      } else if (timePassed.inMinutes < 60) {
        if (timePassed.inMinutes == 1) {
          updateText = Strings.get("last_update") + Strings.get("1_min_ago");
        } else {
          updateText = sprintf(Strings.get("last_update") + Strings.get("min_ago"), [timePassed.inMinutes.toString()]);
        }
      } else if (timePassed.inHours < 24) {
        if (timePassed.inHours == 1) {
          updateText = Strings.get("last_update") + Strings.get("1_hr_ago");
        } else {
          updateText = sprintf(Strings.get("last_update") + Strings.get("hr_ago"), [timePassed.inHours.toString()]);
        }
      } else {
        updateText = Strings.get("last_update") + "${lastUpdateTime.month}/${lastUpdateTime.day}";
      }
    } else {
      updateText = Strings.get("last_update") + Strings.get("unknown");
    }

    return updateText;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: Icon(Icons.menu),
          onPressed: widget.onOpenDrawer,
        ),
      ),
      title: Image(
        image: AssetImage("assets/icons/app_logo_${isAndroid()?"android":"ios"}_small.png"),
        height: 40,
        width: 40,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.isAutoRefreshing)
                SpinKitDualRing(
                  color: getGrey(100, context: context),
                  lineWidth: 1.5,
                  size: 18,
                  duration: const Duration(milliseconds: 700),
                ),
              SizedBox(width: 4),
              Text(
                getUpdateText(),
                textAlign: TextAlign.end,
                style: TextStyle(color: getGrey(100, context: context)),
              ),
            ],
          ),
        ),
      ],
      floating: widget.hasActiveCourses,
      snap: widget.hasActiveCourses,
      elevation: widget.hasActiveCourses ? null : 0,
      pinned: !widget.hasActiveCourses,
    );
  }
}
