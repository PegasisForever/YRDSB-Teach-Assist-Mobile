import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/res/Strings.dart';
import 'package:sprintf/sprintf.dart';
import '../tools.dart';
import '../widgets/user_accounts_drawer_header.dart' as UADrawerHeader;

class SummaryPage extends StatefulWidget {
  SummaryPage() : super();

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with AfterLayoutMixin<SummaryPage> {
  var _accountSelectorHeight = 0.0;
  var drawerHeaderOpened=false;

  @override
  Widget build(BuildContext context) {
    if (userList.length == 0) {
      return Container();
    }

    adjustNavColor(context);
    Strings.updateCurrentLanguage(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            sprintf(Strings.get("report_for_student"),[currentUser.getName()]),
            maxLines: 2,
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: Strings.get("summary")),
              Tab(text: Strings.get("time_line"))
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UADrawerHeader.UserAccountsDrawerHeader(
                isOpened: drawerHeaderOpened,
                accountName: Text(currentUser.displayName == ""
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
                    if (!drawerHeaderOpened) {
                      _accountSelectorHeight = 64.0;
                      userList.forEach((user){
                        if (user.number!=currentUser.number){
                          if(user.displayName==""){
                            _accountSelectorHeight+=48;
                          }else{
                            _accountSelectorHeight+=64;
                          }
                        }
                      });
                    } else {
                      _accountSelectorHeight = 0;
                    }
                    drawerHeaderOpened=!drawerHeaderOpened;
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
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                saveCourseListOf(currentUser.number, await getMark(currentUser));
              },
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: _getsummaryCards(),
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _getsummaryCards(){
    var list=List<Widget>();
    var courses=getCourseListOf(currentUser.number);

    courses.forEach((course){
      var infoStr=[];
      if (course.block!=""){
        infoStr.add(sprintf(Strings.get("period_number"),[course.block]));
      }
      if (course.room!=""){
        infoStr.add(sprintf(Strings.get("room_number"),[course.room]));
      }
      list.add(Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(course.name==""?course.code:course.name,
                    style: Theme.of(context).textTheme.title),
                SizedBox(height: 4),
                Text(infoStr.join("  -  "),
                    style: Theme.of(context).textTheme.subhead),
                SizedBox(height: 16),
                course.overallMark!="N/A"?
                LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 500,
                  percent: double.parse(course.overallMark)/100,
                  center: Text(course.overallMark+"%",
                  style: TextStyle(color: Colors.black)),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.lightGreenAccent,
                ):LinearPercentIndicator(
                  lineHeight: 20.0,
                  percent: 0,
                  center: Text(Strings.get("marks_unavailable"),
                      style: TextStyle(color: Colors.black)),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.lightGreenAccent,
                ),
              ],
            ),
          ),
        ),
      ));
    });

    return list;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (userList.length == 0) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {}
  }

  List<Widget> getAccountSelectorList(){
    var list = <Widget>[];
    for (var user in userList) if(user.number!=currentUser.number){
      list.add(ListTile(
        title: Text(user.displayName == ""
            ? user.number
            : user.displayName),
        subtitle: user.displayName == ""
            ? null
            : Text(user.number),
        dense: true,
        onTap: () {
          setState(() {
            setCurrentUser(user);
            drawerHeaderOpened=false;
            _accountSelectorHeight=0;
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
          drawerHeaderOpened=false;
          _accountSelectorHeight=0;
        });
        Navigator.pushNamed(context, "/accounts_list");
      },
    ));

    list.add(Divider());

    return list;
  }
}