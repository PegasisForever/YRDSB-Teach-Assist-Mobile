import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/res/Themes.dart';

import '../../widgets/user_accounts_drawer_header.dart' as UADrawerHeader;

class SummaryPageDrawer extends StatefulWidget {
  SummaryPageDrawer({this.onUserSelected});

  final ValueChanged<User> onUserSelected;

  @override
  _SummaryPageDrawerState createState() => _SummaryPageDrawerState();
}

class _SummaryPageDrawerState extends State<SummaryPageDrawer> {
  var _drawerHeaderOpened = false;
  var _accountSelectorHeight = 0.0;
  ValueChanged<User> _onUserSelected = null;

  @override
  void initState() {
    super.initState();

    _onUserSelected = widget.onUserSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollConfiguration(
        behavior: DisableOverScroll(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UADrawerHeader.UserAccountsDrawerHeader(
              isOpened: _drawerHeaderOpened,
              accountName: Text(
                  currentUser.displayName == "" ? currentUser.number : currentUser.displayName),
              accountEmail: currentUser.displayName == "" ? null : Text(currentUser.number),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  (currentUser.displayName == ""
                      ? currentUser.number.substring(7, 9)
                      : (currentUser.displayName.length > 2
                          ? currentUser.displayName.substring(0, 2)
                          : currentUser.displayName)),
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
            ),
            ListTile(
              title: Text(Strings.get("moodle")),
              leading: Image.asset(
                "assets/images/moodle_logo.png",
                height: 28,
                width: 28,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/moodle");
              },
            ),
            ListTile(
              title: Text(Strings.get("archived_marks")),
              leading: Icon(Icons.archive),
            ),
            ListTile(
              title: Text(Strings.get("announcements")),
              leading: Icon(Icons.notifications),
            ),
            ListTile(
              title: Text(Strings.get("feedback")),
              leading: Icon(Icons.message),
            ),
            ListTile(
              title: Text(Strings.get("settings")),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text(Strings.get("about")),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/about");
              },
            ),
            ListTile(
              title: Text(Strings.get("donate")),
              leading: Icon(Icons.monetization_on),
            )
          ],
        ),
      ),
    );
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
            _onUserSelected(user);
            setState(() {
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
