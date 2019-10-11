import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}
