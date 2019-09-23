import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(new LifecycleEventHandler(() {
      adjustNavColor(context);
      return;
    }));
  }

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
            'Report for 349891234',
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
              onRefresh: () {
                return;
              },
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Functions and Relations",
                                style: Theme.of(context).textTheme.title),
                            SizedBox(height: 4),
                            Text("Rm. 233",
                                style: Theme.of(context).textTheme.subhead),
                            SizedBox(height: 16),
                            LinearPercentIndicator(
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 500,
                              percent: 0.9,
                              center: Text("90.0%"),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.lightGreenAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (userList.length == 0) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {}
    adjustNavColor(context);
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