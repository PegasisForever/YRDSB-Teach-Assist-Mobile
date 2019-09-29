import 'package:flutter/material.dart';

class Strings {
  static var _currentLanguage;
  static var _strings = {
    "en": {
      "login_your_account": "Login Your Account:",
      "student_number":"Student Number",
      "password":"Password",
      "login":"Login",
      "plz_fill_in_ur_student_number":"Please fill in your student number",
      "plz_fill_in_ur_pwd":"Please fill in your password",
      "connection_failed":"Connection failed",
      "student_number_or_password_incorrect":"Student number or password incorrect",
      "server_internal_error":"Server internal error",
      "error_code":"Error code: ",
      "summary":"Summary",
      "time_line":"Time Line",
      "share_marks":"Share Marks",
      "archived_marks":"Archived Courses",
      "announcements":"Announcements",
      "feedback":"Feedback",
      "settings":"Settings",
      "about":"About",
      "donate":"Donate",
      "edit_accounts":"Edit Accounts",
      "manage_accounts":"Manage Accounts",
      "accounts_list":"Accounts List",
      "edit":"Edit",
      "add_a_new_account":"Add a New Account",
      "alias_optional":"Alias (Optional)",
      "receive_notifications":"Receive notifications",
      "this_account_already_exists":"This account already exists",
      "remove_account":"Remove Account",
      "?":"?",
      "cancel":"Cancel",
      "remove":"Remove",
      "removing":"Removing...",
      "long_press_and_drag_to_reorder_the_list":"Long press and drag to reorder the list",
      "report_for_student":"Report for %s",
      "room_number":"Room %s",
      "marks_unavailable":"Marks unavailable",
      "period_number":"Period %s",
      "assignments":"Assignments",
      "statics":"Statics",
      "assignments_unavailable":"Assignments Unavailable",
      "statics_unavailable":"Statics Unavailable",
      "course_about_name:":"Course Name: ",
      "course_about_code:":"Course Code: ",
      "course_about_period:":"Period: ",
      "course_about_room:":"Room: ",
      "course_about_starttime:":"Start Time: ",
      "course_about_endtime:":"End Time: ",
      "unknown":"Unknown",
      "knowledge_understanding":"Knowledge / Understanding",
      "thinking":"Thinking",
      "communication":"Communication",
      "application":"Application",
      "overall":"Overall",

    },
    "zh": {
      "login_your_account": "登录帐号：",
      "student_number":"学生号",
      "password":"密码",
    }
  };

  static updateCurrentLanguage(BuildContext context) {
    _currentLanguage = Localizations.localeOf(context).languageCode;
  }

  static String get(String id, [BuildContext context]) {
    if (_currentLanguage == null) {
      updateCurrentLanguage(context);
    }
    var string = _strings[_currentLanguage][id];
    if (string == null) {
      print("Cannot find id:$id in $_currentLanguage");
      string = "unknown";
    }
    return string;
  }
}
