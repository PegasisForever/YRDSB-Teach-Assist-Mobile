import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/drawerpages/SearchPage.dart';
import 'package:ta/pages/drawerpages/TADrawer.dart';
import 'package:ta/pages/drawerpages/openCustomTab.dart';
import 'package:ta/pages/summarypage/SummaryAppBar.dart';
import 'package:ta/pages/summarypage/courselist/SummaryCourseList.dart';
import 'package:ta/pages/summarypage/section/AnnouncementSection.dart';
import 'package:ta/pages/summarypage/section/CalendarSection.dart';
import 'package:ta/pages/summarypage/section/InitSetupSection.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/pages/summarypage/section/UpdatesSection.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/plugins/firebase.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends BetterState<SummaryPage>
    with AfterLayoutMixin<SummaryPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool autoRefreshing = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final sidePadding = (getScreenWidth(context) - 500) / 2;
    final hasActiveCourses = getCourseListOf(currentUser.number).length > 0;
    var mainWidget;
    if (hasActiveCourses) {
      mainWidget = ListView(
        padding: EdgeInsets.only(
          left: max(sidePadding, 14),
          right: max(sidePadding, 14),
          bottom: getBottomPadding(context) + 16,
        ),
        children: getSectionWidgets([
          InitSetupSection(),
          AnnouncementSection(),
          CalendarSection(),
          UpdatesSection(),
        ])
          ..add(FlatButton(
            child: Text("setState"),
            onPressed: () {
              setState(() {});
            },
          ))
          ..add(SummaryCourseList()),
      );
    } else {
      final theme = Theme.of(context);
      final lightLinkColor = theme.primaryColor;
      final darkLinkColor = theme.primaryColorLight;

      mainWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: Strings.get("no_active_courses"),
                style: Theme.of(context).textTheme.subhead,
              ),
              TextSpan(
                text: Strings.get("archived_marks"),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.pushNamed(context, "/archived"),
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: isLightMode(context: context)
                          ? lightLinkColor
                          : darkLinkColor,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SummaryPageAppBar(
            onOpenDrawer: () {
              scaffoldKey.currentState.openDrawer();
            },
            isAutoRefreshing: autoRefreshing,
            hasActiveCourses: hasActiveCourses,
          ),
        ],
        body: SmartRefresher(
          header: ClassicHeader(
            textStyle: TextStyle(color: getGrey(100, context: context)),
            idleText: Strings.get("pull_down_to_refresh"),
            releaseText: Strings.get("release_to_refresh"),
            refreshingText: Strings.get("refreshing"),
            completeText: Strings.get("refresh_completed"),
            failedText: Strings.get("refresh_failed"),
            refreshStyle: RefreshStyle.UnFollow,
          ),
          controller: _refreshController,
          onRefresh: manualRefresh,
          child: mainWidget,
        ),
      ),
      drawer: TADrawer(
        onUserSelected: (user) {
          setState(() {
            setCurrentUser(user);
            startAutoRefresh();
          });
        },
        onOpenSearch: () {
          showSearch(
            context: context,
            delegate: AssignmentSearchDelegate(),
          );
        },
      ),
    );
  }

  @override
  afterFirstLayout(BuildContext context) {
    if (prefs.getBool("show_no_google_play_warning") ??
        true && supportsGooglePlay() == false) {
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

    firebaseRequestNotificationPermissions();

    startAutoRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startAutoRefresh();
    }
  }

  Future<void> manualRefresh() async {
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
      handleError(e);
      _refreshController.refreshFailed();
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
        DateTime.now().difference(DateTime.parse(lastUpdateTime)).inMinutes <
            5)) {
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
                    openCustomTab(context, "https://ta-yrdsb.web.app/update");
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
