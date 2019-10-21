import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/SummaryTab.dart';
import 'package:ta/pages/summarypage/TimelineTab.dart';
import 'package:ta/res/Strings.dart';
import 'package:sprintf/sprintf.dart';
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

class _SummaryPageState extends State<SummaryPage>
    with AfterLayoutMixin<SummaryPage>, RouteAware {
  final _needRefresh;

  _SummaryPageState(this._needRefresh);

  @override
  Widget build(BuildContext context) {
    Strings.updateCurrentLanguage(context);

    if (userList.length == 0) {
      return Container();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            sprintf(Strings.get("report_for_student"), [currentUser.getName()]),
            maxLines: 2,
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: Strings.get("summary")),
              Tab(text: Strings.get("time_line"))
            ],
          ),
        ),
        drawer: SummaryPageDrawer(onUserSelected: (user) {
          setState(() {
            setCurrentUser(user);
          });
        }),
        body: TabBarView(
          children: <Widget>[
            SummaryTab(needRefresh: _needRefresh),
            TimelineTab()
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (userList.length == 0) {
      Navigator.pushReplacementNamed(context, "/login");
    } else if(prefs.getBool("show_no_google_play_warning") ?? true && !supportsGooglePlay() && firebaseInited) {
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
                    prefs.setBool("show_no_google_play_warning",false);
                    Navigator.pop(context);
                  },
                ),
              ],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            );
          });
    }
  }
}
