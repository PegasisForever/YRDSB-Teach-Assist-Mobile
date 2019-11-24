import 'package:flutter/material.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/main.dart';
import 'package:ta/pages/settingspage/SelectColorDialog.dart';
import 'package:ta/res/Strings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("settings")),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Manage Accounts"),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.pushNamed(context, "/accounts_list");
            },
          ),
          ListTile(
            title: Text("Dark mode"),
            leading: Icon(Icons.brightness_4),
            trailing: DropdownButton<int>(
                value: Config.darkMode,
                onChanged: (v) {
                  App.updateBrightness(v);
                },
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text("Force light mode"),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Follow system"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Force dark mode"),
                  ),
                ]),
          ),
          ListTile(
            title: Text("Primary color"),
            leading: Icon(Icons.color_lens),
            trailing: Container(
              width: 24.0,
              height: 24.0,
              decoration: new BoxDecoration(
                color: Config.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SelectColorDialog();
                  });
            },
          ),
          ListTile(
            title: Text("Default first page"),
            leading: Icon(Icons.home),
            trailing: DropdownButton<int>(
                value: Config.firstPage,
                onChanged: (v) {
                  setState(() {
                    Config.firstPage = v;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text("Summary"),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Time Line"),
                  ),
                ]),
          ),
          ListTile(
            title: Text("Show more decimal places"),
            leading: Icon(Icons.exposure_plus_2),
            trailing: Switch(
              value: Config.showMoreDecimal,
              onChanged: (v) {
                setState(() {
                  Config.showMoreDecimal = v;
                });
              },
            ),
            onTap: () {
              setState(() {
                Config.showMoreDecimal = !Config.showMoreDecimal;
              });
            },
          )
        ],
      ),
    );
  }
}
