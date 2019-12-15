import 'package:flutter/material.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/main.dart';
import 'package:ta/pages/settingspage/SelectColorDialog.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var sidePadding = (widthOf(context) - 500) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("settings")),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: sidePadding > 0 ? sidePadding : 0,
        ),
        children: <Widget>[
          ListTile(
            title: Text(Strings.get("manage_accounts_alt")),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.pushNamed(context, "/accounts_list");
            },
          ),
          ListTile(
            title: Text(Strings.get("language")),
            leading: Icon(Icons.translate),
            trailing: DropdownButton<String>(
                value: Config.language,
                onChanged: (v) {
                  setState(() {
                    Config.language=v;
                    Strings.updateCurrentLanguage(context);
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(Strings.get("follow_system")),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: Text(Languages["en"]),
                  ),
                  DropdownMenuItem(
                    value: "zh",
                    child: Text(Languages["zh"]),
                  ),
                ]),
          ),
          ListTile(
            title: Text(Strings.get("dark_mode")),
            leading: Icon(Icons.brightness_4),
            trailing: DropdownButton<int>(
                value: Config.darkMode,
                onChanged: (v) {
                  App.updateBrightness(v);
                },
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(Strings.get("force_light")),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(Strings.get("follow_system")),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text(Strings.get("force_dark")),
                  ),
                ]),
          ),
          ListTile(
            title: Text(Strings.get("primary_color")),
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
            title: Text(Strings.get("default_first_page")),
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
                    child: Text(Strings.get("summary")),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(Strings.get("time_line")),
                  ),
                ]),
          ),
          ListTile(
            title: Text(Strings.get("show_more_decimal_places")),
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
          ),
          Builder(
              builder: (context) {
                return ListTile(
                  title: Text(Strings.get("reset_all_tips")),
                  leading: Icon(Icons.assistant),
                  onTap: () {
                    prefs.setBool("show_what_if_tip", true);
                    prefs.setBool("show_tap_to_view_detail_tip", true);
                    prefs.setBool("show_assi_edit_tip", true);
                    showSnackBar(context, Strings.get("tips_reset"));
                  },
                );
              }
          )
        ],
      ),
    );
  }
}
