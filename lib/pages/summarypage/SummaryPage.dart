import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/pages/drawerpages/EditAccount.dart';
import 'package:ta/pages/summarypage/SearchPage.dart';
import 'package:ta/pages/summarypage/SummaryTab.dart';
import 'package:ta/pages/summarypage/TimelineTab.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

import '../../dataStore.dart';
import '../../firebase.dart';
import 'SummaryPageDrawer.dart';

class SummaryPage extends StatefulWidget {
  var needRefresh = true;

  SummaryPage() : super();

  SummaryPage.noRefresh() : super() {
    needRefresh = false;
  }

  @override
  _SummaryPageState createState() => _SummaryPageState(needRefresh);
}

class _SummaryPageState extends BetterState<SummaryPage> with AfterLayoutMixin<SummaryPage> {
  final _needRefresh;
  List<Course> courses;
  List<TAUpdate> timeline;
  String number;

  _SummaryPageState(this._needRefresh);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userList.length == 0) {
      return Container();
    }

    if (number != currentUser.number) {
      number = currentUser.number;
      readData();
    }

    return DefaultTabController(
      length: 2,
      initialIndex: Config.firstPage,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            sprintf(Strings.get("report_for_student"), [currentUser.getName()]),
            maxLines: 2,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: AssignmentSearchDelegate(),
                );
              },
            )
          ],
          bottom: TabBar(
            isScrollable: widthOf(context) > 500,
            indicatorColor: Colors.white,
            tabs: <Widget>[Tab(text: Strings.get("summary")), Tab(text: Strings.get("time_line"))],
          ),
        ),
        drawer: SummaryPageDrawer(onUserSelected: (user) {
          setState(() {
            setCurrentUser(user);
          });
        }),
        body: TabBarView(
          children: <Widget>[
            SummaryTab(
              courses: courses,
              needRefresh: _needRefresh,
              onRefresh: onRefresh,
            ),
            TimelineTab(
              courses: courses,
              timeline: timeline,
            ),
          ],
        ),
      ),
    );
  }

  @override
  afterFirstLayout(BuildContext context) {
    if (userList.length == 0) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    precacheImage(Image.asset("assets/images/app_logo.png").image, context);

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
  }

  readData() {
    courses = getCourseListOf(currentUser.number);
    timeline = getTimelineOf(currentUser.number);
  }

  Future<void> onRefresh() async {
    try {
      await getAndSaveMarkTimeline(currentUser);
      setState(() {
        readData();
      });
    } catch (e) {
      handleError(e);
    }
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
                    OpenAppstore.launch(androidAppId: "site.pegasis.yrdsb.ta", iOSAppId: "1483082868");
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditAccount(currentUser, true)),
                      );
                    }),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    }
  }
}
