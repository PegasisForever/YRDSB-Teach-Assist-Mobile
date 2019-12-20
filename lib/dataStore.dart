import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}

const ColorMap = {
  "blue": Colors.blue,
  "purple": Colors.purple,
  "deep_purple": Colors.deepPurple,
  "indigo": Colors.indigo,
  "teal": Colors.teal,
  "brown": Colors.brown,
};

class Config {
  static int get darkMode {
    return prefs.getInt("dark_mode") ?? 1;
  }

  static set darkMode(int v) {
    prefs.setInt("dark_mode", v);
  }

  static MaterialColor get primaryColor {
    return ColorMap[prefs.getString("primary_color") ?? "blue"];
  }

  static set primaryColor(MaterialColor color) {
    ColorMap.forEach((k, v) {
      if (v == color) {
        prefs.setString("primary_color", k);
      }
    });
  }

  static int get firstPage {
    return prefs.getInt("default_first_page") ?? 0;
  }

  static set firstPage(int v) {
    prefs.setInt("default_first_page", v);
  }

  static bool get showMoreDecimal {
    return prefs.getBool("show_more_decimal") ?? false;
  }

  static set showMoreDecimal(bool v) {
    prefs.setBool("show_more_decimal", v);
  }

  static String get firebaseToken{
    return prefs.getString("firebase_token") ?? null;
  }

  static set firebaseToken(String token){
    prefs.setString("firebase_token", token);
  }

  static String get language{
    return prefs.getString("language");
  }

  static set language(String lang){
    prefs.setString("language", lang);
  }

  static bool get hideAppContent{
    return prefs.getBool("hide_app_content") ?? true;
  }

  static set hideAppContent(bool v){
    prefs.setBool("hide_app_content", v);
  }
}
