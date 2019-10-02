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
      "login":"登录",
      "plz_fill_in_ur_student_number":"请输入学生号",
      "plz_fill_in_ur_pwd":"请输入密码",
      "connection_failed":"网络连接失败",
      "student_number_or_password_incorrect":"学生号或密码错误",
      "server_internal_error":"服务器内部错误",
      "error_code":"错误代码：",
      "summary":"概要",
      "time_line":"动态",
      "share_marks":"分享分数",
      "archived_marks":"已归档",
      "announcements":"通知",
      "feedback":"反馈",
      "settings":"设置",
      "about":"关于",
      "donate":"捐助",
      "manage_accounts":"管理账户",
      "accounts_list":"账户列表",
      "edit":"编辑",
      "add_a_new_account":"添加账户",
      "alias_optional":"昵称（可选）",
      "receive_notifications":"接收通知",
      "this_account_already_exists":"这个账户已存在",
      "remove_account":"移除帐号",
      "?":"？",
      "cancel":"取消",
      "remove":"移除",
      "removing":"正在移除...",
      "long_press_and_drag_to_reorder_the_list":"长按并拖动以重新排序",
      "report_for_student":"%s的成绩",
      "room_number":"%s教室",
      "marks_unavailable":"暂无分数",
      "period_number":"第%s节课",
      "assignments":"作业评分",
      "statics":"统计",
      "assignments_unavailable":"暂无作业评分",
      "statics_unavailable":"暂无统计数据",
      "course_about_name:":"课程名称：",
      "course_about_code:":"课程代码：",
      "course_about_period:":"时间段：",
      "course_about_room:":"教室：",
      "course_about_starttime:":"开始时间：",
      "course_about_endtime:":"结束时间：",
      "unknown":"未知",
      "knowledge_understanding":"知识",
      "thinking":"思考",
      "communication":"交流",
      "application":"应用",
      "overall":"总分",
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
      string = get("unknown");
    }
    return string;
  }
}
