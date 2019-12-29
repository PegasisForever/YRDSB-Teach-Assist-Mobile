import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_privacy_screen/flutter_privacy_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/main.dart';
import 'package:ta/model/User.dart';
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
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: max(sidePadding, 0),
          right: max(sidePadding, 0),
          bottom: MediaQuery.of(context).padding.bottom,
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
                    Config.language = v;
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
            title: Text(Strings.get("privacy_mode")),
            subtitle:
                Text(Strings.get("hide_in_app_switcher_" + (isAndroid() ? "android" : "ios"))),
            leading: Icon(Icons.visibility_off),
            trailing: Switch(
              value: Config.hideAppContent,
              onChanged: (v) {
                setState(() {
                  Config.hideAppContent = v;
                  if (Config.hideAppContent) {
                    FlutterPrivacyScreen.enablePrivacyScreen();
                  } else {
                    FlutterPrivacyScreen.disablePrivacyScreen();
                  }
                });
              },
            ),
            onTap: () {
              setState(() {
                Config.hideAppContent = !Config.hideAppContent;
                if (Config.hideAppContent) {
                  FlutterPrivacyScreen.enablePrivacyScreen();
                } else {
                  FlutterPrivacyScreen.disablePrivacyScreen();
                }
              });
            },
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
          Builder(builder: (context) {
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
          }),
          ListTile(
            title: Text(Strings.get("export_data")),
            leading: Icon(Icons.save),
            onTap: () async {
              var markJSON = jsonDecode(prefs.getString("${currentUser.number}-mark") ?? "[]");
              var archivedJSON =
                  jsonDecode(prefs.getString("${currentUser.number}-archived") ?? "[]");
              var timelineJSON =
                  jsonDecode(prefs.getString("${currentUser.number}-timeline") ?? "[]");
              var exportJSONString = jsonEncode({
                "courses": markJSON,
                "archived_courses": archivedJSON,
                "timeline": timelineJSON
              });

              Directory dir = await getApplicationDocumentsDirectory();
              File testFile = new File("${dir.path}/export.json");
              testFile.writeAsStringSync(exportJSONString);
              ShareExtend.share(testFile.path, "file");
            },
          ),
        ],
      ),
    );
  }
}
