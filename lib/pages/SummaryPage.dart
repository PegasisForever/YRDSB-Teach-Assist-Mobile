import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/res/Strings.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/res/Themes.dart';
import '../tools.dart';
import '../widgets/user_accounts_drawer_header.dart' as UADrawerHeader;
import 'detailpage/DetailPage.dart';

class SummaryPage extends StatefulWidget {
  var needRefresh=true;

  SummaryPage() : super();

  SummaryPage.norefresh():super(){
    needRefresh=false;
  }

  @override
  _SummaryPageState createState() => _SummaryPageState(needRefresh);
}

class _SummaryPageState extends State<SummaryPage>
    with AfterLayoutMixin<SummaryPage> {
  var _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _accountSelectorHeight = 0.0;
  var _drawerHeaderOpened = false;
  var _courses = userList.length != 0?getCourseListOf(currentUser.number):null;
  final _needRefresh;

  _SummaryPageState(this._needRefresh);


  @override
  Widget build(BuildContext context) {
    if (userList.length == 0) {
      return Container();
    }

    Strings.updateCurrentLanguage(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        drawer: Drawer(
          child: ScrollConfiguration(
            behavior: DisableOverScroll(),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UADrawerHeader.UserAccountsDrawerHeader(
                  isOpened: _drawerHeaderOpened,
                  accountName: Text(
                      currentUser.displayName == ""
                          ? currentUser.number
                          : currentUser.displayName),
                  accountEmail: currentUser.displayName == ""
                      ? null
                      : Text(currentUser.number),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      (currentUser.displayName == ""
                          ? currentUser.number.substring(7, 9)
                          : currentUser.displayName.substring(0, 2)),
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                  onDetailsPressed: () {
                    setState(() {
                      if (!_drawerHeaderOpened) {
                        _accountSelectorHeight = 64.0;
                        userList.forEach((user) {
                          if (user.number != currentUser.number) {
                            if (user.displayName == "") {
                              _accountSelectorHeight += 48;
                            } else {
                              _accountSelectorHeight += 64;
                            }
                          }
                        });
                      } else {
                        _accountSelectorHeight = 0;
                      }
                      _drawerHeaderOpened = !_drawerHeaderOpened;
                    });
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  height: _accountSelectorHeight,
                  child: Column(
                    children: getAccountSelectorList(),
                  ),
                ),
                ListTile(
                  title: Text(Strings.get("share_marks")),
                  leading: Icon(Icons.share),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("archived_marks")),
                  leading: Icon(Icons.archive),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("announcements")),
                  leading: Icon(Icons.notifications),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("feedback")),
                  leading: Icon(Icons.message),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("settings")),
                  leading: Icon(Icons.settings),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("about")),
                  leading: Icon(Icons.info),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(Strings.get("donate")),
                  leading: Icon(Icons.monetization_on),
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                await getAndSaveMark(currentUser);
                setState(() {
                  _courses = getCourseListOf(currentUser.number);
                  print("Manual refreshed");
                });
              },
              child: ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: _getsummaryCards(_courses),
              ),
            ),
            Center(child: Text(Strings.get("in_development")))
          ],
        ),
      ),
    );
  }

  List<Widget> _getsummaryCards(List<Course> courses) {
    var list = List<Widget>();

    var total=0.0;
    var availableCourseCount=0;

    courses.forEach((course) {
      if (course.overallMark!=null){
        total+=course.overallMark;
        availableCourseCount++;
      }
      var infoStr = [];
      if (course.block != "") {
        infoStr.add(sprintf(Strings.get("period_number"), [course.block]));
      }
      if (course.room != "") {
        infoStr.add(sprintf(Strings.get("room_number"), [course.room]));
      }
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage(course)),
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(course.displayName,
                      style: Theme.of(context).textTheme.title),
                  SizedBox(height: 4),
                  Text(infoStr.join("  -  "),
                      style: Theme.of(context).textTheme.subhead),
                  SizedBox(height: 16),
                  course.overallMark != null
                      ? LinearPercentIndicator(
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 500,
                          percent: course.overallMark / 100,
                          center: Text(course.overallMark.toString() + "%",
                              style: TextStyle(color: Colors.black)),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Theme.of(context).colorScheme.secondary,
                        )
                      : LinearPercentIndicator(
                          lineHeight: 20.0,
                          percent: 0,
                          center: Text(Strings.get("marks_unavailable"),
                              style: TextStyle(color: Colors.black)),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                        ),
                ],
              ),
            ),
          ),
        ),
      ));
    });

    if (availableCourseCount>0){
      list.insert(0, Divider());

      var avg=total/availableCourseCount;
      list.insert(0, Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.get("average"),
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              getRoundString(avg, 1) + "%",
              style: TextStyle(fontSize: 60),
            ),
            LinearPercentIndicator(
              animation: false,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: avg / 100,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ));
    }

    return list;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (userList.length == 0) {
      Navigator.pushReplacementNamed(context, "/login");
    } else if(_needRefresh) {
      _refreshIndicatorKey.currentState.show();
    }
  }

  List<Widget> getAccountSelectorList() {
    var list = <Widget>[];
    for (var user in userList)
      if (user.number != currentUser.number) {
        list.add(ListTile(
          title: Text(user.displayName == "" ? user.number : user.displayName),
          subtitle: user.displayName == "" ? null : Text(user.number),
          dense: true,
          onTap: () {
            setState(() {
              setCurrentUser(user);
              _courses = getCourseListOf(currentUser.number);
              _drawerHeaderOpened = false;
              _accountSelectorHeight = 0;
            });
            Navigator.pop(context);
          },
        ));
      }

    list.add(ListTile(
      title: Text(Strings.get("manage_accounts")),
      leading: Icon(Icons.sort),
      dense: true,
      onTap: () {
        setState(() {
          _drawerHeaderOpened = false;
          _accountSelectorHeight = 0;
        });
        Navigator.pushNamed(context, "/accounts_list");
      },
    ));

    list.add(Divider());

    return list;
  }
}
