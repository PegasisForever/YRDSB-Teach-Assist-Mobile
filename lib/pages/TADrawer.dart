import 'package:flutter/material.dart' hide UserAccountsDrawerHeader;
import 'package:ta/model/User.dart';
import 'package:ta/pages/drawerpages/openCustomTab.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/res/Themes.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/user_accounts_drawer_header.dart';

class TADrawer extends StatefulWidget {
  TADrawer({this.onUserSelected});

  final ValueChanged<User> onUserSelected;

  @override
  _TADrawerState createState() => _TADrawerState();
}

class _TADrawerState extends State<TADrawer> {
  var _drawerHeaderOpened = false;
  ValueChanged<User> _onUserSelected;

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
          UserAccountsDrawerHeader(
            isOpened: _drawerHeaderOpened,
            accountName:
                Text(currentUser.displayName == "" ? currentUser.number : currentUser.displayName),
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
                _drawerHeaderOpened = !_drawerHeaderOpened;
              });
            },
          ),
          CrossFade(
            firstChild: Column(
              children: getAccountSelectorList(),
            ),
            secondChild: Container(),
            showFirst: _drawerHeaderOpened,
          ),
          ListTile(
            title: Text(Strings.get("moodle")),
            leading: Image.asset(
              isLightMode(context: context)
                  ? "assets/icons/moodle_logo.png"
                  : "assets/icons/moodle_logo_ondark.png",
              height: 28,
              width: 28,
            ),
            onTap: () {
              Navigator.pop(context);
              openCustomTab(context, "https://moodle2.yrdsb.ca/");
            },
          ),
          ListTile(
            title: Text(Strings.get("archived_marks")),
            leading: Icon(Icons.archive),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/archived");
            },
          ),
          ListTile(
            title: Text(Strings.get("feedback")),
            leading: Icon(Icons.message),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/feedback");
            },
          ),
          ListTile(
            title: Text(Strings.get("settings")),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/settings");
            },
          ),
          ListTile(
            title: Text(Strings.get("about")),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/about");
            },
          ),
        ],
      ),
    ));
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
        });
        Navigator.pushNamed(context, "/accounts_list");
      },
    ));

    list.add(Divider());

    return list;
  }
}
