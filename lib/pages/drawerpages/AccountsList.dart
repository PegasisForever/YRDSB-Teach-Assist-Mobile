import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class AccountsList extends StatefulWidget {
  @override
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends BetterState<AccountsList> {
  @override
  Widget build(BuildContext context) {
    var sidePadding = (widthOf(context) - 500) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("accounts_list")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/accounts_list/edit",
                arguments: [User.blank(), false],
              );
            },
          )
        ],
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: ReorderableListView(
        padding: EdgeInsets.only(
          left: max(sidePadding, 0),
          right: max(sidePadding, 0),
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            reorderUser(oldIndex, newIndex);
          });
        },
        header: userList.length > 1
            ? Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  Strings.get("long_press_and_drag_to_reorder_the_list"),
                  style: Theme.of(context).textTheme.caption,
                ),
              )
            : null,
        children: getAccountListTiles(),
      ),
    );
  }

  List<Widget> getAccountListTiles() {
    var widgets = <Widget>[];
    for (final user in userList) {
      widgets.add(ListTile(
        key: ValueKey(user.number),
        title: Text(user.displayName == "" ? user.number : user.displayName),
        subtitle: user.displayName == "" ? null : Text(user.number),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/accounts_list/edit",
              arguments: [user, false],
            );
          },
        ),
      ));
    }

    return widgets;
  }
}
