import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/firebase.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/TADrawer.dart';
import 'package:ta/pages/summarypage/SummaryCourseList.dart';
import 'package:ta/pages/summarypage/section/AnnouncementSection.dart';
import 'package:ta/pages/summarypage/section/CalendarSection.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/pages/summarypage/section/UpdatesSection.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends BetterState<SummaryPage> with AfterLayoutMixin<SummaryPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Timer timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool autoRefreshing = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(new Duration(minutes: 1), (timer) {
      setState(() {}); //update "updateText"
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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
          updateText = sprintf(Strings.get("last_update") + Strings.get("min_ago"),
              [timePassed.inMinutes.toString()]);
        }
      } else if (timePassed.inHours < 24) {
        if (timePassed.inHours == 1) {
          updateText = Strings.get("last_update") + Strings.get("1_hr_ago");
        } else {
          updateText = sprintf(
              Strings.get("last_update") + Strings.get("hr_ago"), [timePassed.inHours.toString()]);
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
    super.build(context);
    if (userList.length == 0) {
      return Container();
    }

    var sidePadding = (widthOf(context) - 500) / 2;

    return Scaffold(
      key: scaffoldKey,
      body: SmartRefresher(
        enablePullDown: true,
        header: ClassicHeader(
          textStyle: TextStyle(color: getGrey(100, context: context)),
          idleText: Strings.get("pull_down_to_refresh"),
          releaseText: Strings.get("release_to_refresh"),
          refreshingText: Strings.get("refreshing"),
          completeText: Strings.get("refresh_completed"),
          failedText: Strings.get("refresh_failed"),
          refreshStyle: RefreshStyle.UnFollow,
          outerBuilder: (widget) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: widget,
              ),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: manualRefresh,
        child: ListView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: max(sidePadding, 14),
            right: max(sidePadding, 14),
          ),
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/app_logo_64x.png"),
                  height: 40,
                  width: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(-6, 0),
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (autoRefreshing)
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
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: getSectionWidgets([
                AnnouncementSection(),
                CalendarSection(),
                UpdatesSection(),
              ]),
            ),
            Divider(),
            SummaryCourseList()
          ],
        ),
      ),
      drawer: TADrawer(
        onUserSelected: (user) {
          setState(() {
            setCurrentUser(user);
          });
        },
      ),
    );
  }

  @override
  afterFirstLayout(BuildContext context) {
    if (prefs.getBool("show_no_google_play_warning") ?? true && supportsGooglePlay() == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Strings.get("google_play_services")),
              content: Text(Strings.get("no_google_play_warning_content")),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.get("ok").toUpperCase()),
                  onPressed: () {
                    prefs.setBool("show_no_google_play_warning", false);
                    Navigator.pop(context);
                  },
                ),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    }

    startAutoRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      startAutoRefresh();
    }
  }

  manualRefresh() async {
    try {
      await Future.wait(
        <Future>[
          getAndSaveMarkTimeline(currentUser, noFetch: false),
          getAndSaveCalendar(),
          getAndSaveAnnouncement(),
        ],
        eagerError: true,
      );
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      handleError(e);
    }
    setState(() {});
  }

  startAutoRefresh() {
    autoRefresh(noFetch: true);

    setState(() {
      autoRefreshing = true;
    });
    autoRefresh(
      noFetch: false,
      callBack: () {
        setState(() {
          autoRefreshing = false;
        });
      },
    );
  }

  autoRefresh({bool noFetch, VoidCallback callBack}) async {
    var lastUpdateTime = prefs.getString("last_update-${currentUser.number}");
    if (!(lastUpdateTime != null &&
        DateTime.now().difference(DateTime.parse(lastUpdateTime)).inMinutes < 5)) {
      try {
        await Future.wait(
          <Future>[
            getAndSaveMarkTimeline(currentUser, noFetch: noFetch),
            getAndSaveCalendar(),
            getAndSaveAnnouncement(),
          ],
          eagerError: true,
        );
      } catch (e) {
        handleError(e);
      }
    }

    if (callBack != null) callBack();
    setState(() {});
  }

  handleError(e) {
    if (e.message == "426") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Strings.get("version_no_longer_supported")),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.get("cancel").toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(Strings.get("update").toUpperCase()),
                  onPressed: () {
                    OpenAppstore.launch(
                        androidAppId: "site.pegasis.yrdsb.ta", iOSAppId: "1483082868");
                    Navigator.pop(context);
                  },
                ),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    } else if (e.message == "401") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Strings.get("ur_ta_pwd_has_changed")),
              content: Text(Strings.get("u_need_to_update_your_password")),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.get("cancel").toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text(Strings.get("update_password").toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        "/accounts_list/edit",
                        arguments: [currentUser, true],
                      );
                    }),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    }
  }
}
