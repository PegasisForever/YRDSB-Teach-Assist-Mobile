import 'package:flutter/material.dart';

class Strings {
  static var currentLanguage;
  static var _strings = {
    "en": {
      "login_your_account": "Login Your Account:",
      "student_number": "Student Number",
      "password": "Password",
      "login": "Login",
      "plz_fill_in_ur_student_number": "Please fill in your student number",
      "plz_fill_in_ur_pwd": "Please fill in your password",
      "connection_failed": "Connection failed",
      "student_number_or_password_incorrect": "Student number or password incorrect",
      "server_internal_error": "Server internal error",
      "error_code": "Error code: ",
      "summary": "Summary",
      "time_line": "Time Line",
      "share_marks": "Share Marks",
      "archived_marks": "Archived Courses",
      "announcements": "Announcements",
      "feedback": "Feedback",
      "settings": "Settings",
      "about": "About",
      "donate": "Donate",
      "manage_accounts": "Manage Accounts",
      "accounts_list": "Accounts List",
      "edit": "Edit",
      "add_a_new_account": "Add a New Account",
      "alias_optional": "Alias (Optional)",
      "receive_notifications": "Receive notifications",
      "this_account_already_exists": "This account already exists",
      "remove_account": "Remove Account",
      "?": "?",
      "cancel": "Cancel",
      "remove": "Remove",
      "removing": "Removing...",
      "long_press_and_drag_to_reorder_the_list": "Long press and drag to reorder the list",
      "report_for_student": "Report for %s",
      "room_number": "Room %s",
      "marks_unavailable": "Marks unavailable",
      "period_number": "Period %s",
      "assignments": "Assignments",
      "statistics": "Statistics",
      "assignments_unavailable": "Assignments Unavailable",
      "statistics_unavailable": "Statistics Unavailable",
      "course_about_name:": "Course Name: ",
      "course_about_code:": "Course Code: ",
      "course_about_period:": "Period: ",
      "course_about_room:": "Room: ",
      "course_about_starttime:": "Start Time: ",
      "course_about_endtime:": "End Time: ",
      "unknown": "Unknown",
      "knowledge_understanding": "Knowledge / Understanding",
      "thinking": "Thinking",
      "communication": "Communication",
      "application": "Application",
      "ku": "K/U",
      "t": "T",
      "c": "C",
      "a": "A",
      "f": "Final",
      "o": "Other",
      "ku_single": "K",
      "t_single": "T",
      "c_single": "C",
      "a_single": "A",
      "o_single": "O",
      "w:": "W:",
      "no_weight": "No weight",
      "overall": "Overall",
      "average": "Average",
      "avg:": "Avg: ",
      "untitled_assignment": "Untitled Assignment",
      "in_development": "In Development 🚧",
      "dismiss": "Dismiss",
      "tap_to_view_detail": "You can tap on an item to view its details",
      "google_play_services": "Google Play Services",
      "no_google_play_warning_content": "Google Play services is not supported by your device. "
          "You will not be able to receive notifications.",
      "ok": "OK",
      "moodle": "Moodle",
      "cached": "cached",
      "project_description": "The next-gen Teach Assist client for YRDSB. Project link: ",
      "contact_info": "Contact Infomation",
      "send_feedback": "Send Feedback",
      "plz_fill_in_ur_contact_info": "Please fill in your contact infomation",
      "plz_fill_in_ur_feedback": "Please fill in your feedback",
      "unnamed_course": "Unamed Course",
    },
    "zh": {
      "login_your_account": "登录帐号：",
      "student_number": "学生号",
      "password": "密码",
      "login": "登录",
      "plz_fill_in_ur_student_number": "请输入学生号",
      "plz_fill_in_ur_pwd": "请输入密码",
      "connection_failed": "网络连接失败",
      "student_number_or_password_incorrect": "学生号或密码错误",
      "server_internal_error": "服务器内部错误",
      "error_code": "错误代码：",
      "summary": "概要",
      "time_line": "动态",
      "share_marks": "分享分数",
      "archived_marks": "已归档",
      "announcements": "通知",
      "feedback": "反馈",
      "settings": "设置",
      "about": "关于",
      "donate": "捐助",
      "manage_accounts": "管理账户",
      "accounts_list": "账户列表",
      "edit": "编辑",
      "add_a_new_account": "添加账户",
      "alias_optional": "昵称（可选）",
      "receive_notifications": "接收通知",
      "this_account_already_exists": "这个账户已存在",
      "remove_account": "移除帐号",
      "?": "？",
      "cancel": "取消",
      "remove": "移除",
      "removing": "正在移除...",
      "long_press_and_drag_to_reorder_the_list": "长按并拖动以重新排序",
      "report_for_student": "%s的成绩",
      "room_number": "%s教室",
      "marks_unavailable": "暂无分数",
      "period_number": "第%s节课",
      "assignments": "作业评分",
      "statistics": "统计",
      "assignments_unavailable": "暂无作业评分",
      "statistics_unavailable": "暂无统计数据",
      "course_about_name:": "课程名称：",
      "course_about_code:": "课程代码：",
      "course_about_period:": "时间段：",
      "course_about_room:": "教室：",
      "course_about_starttime:": "开始时间：",
      "course_about_endtime:": "结束时间：",
      "unknown": "未知",
      "knowledge_understanding": "知识",
      "thinking": "思考",
      "communication": "沟通",
      "application": "应用",
      "ku": "知识",
      "t": "思考",
      "c": "沟通",
      "a": "应用",
      "f": "期末",
      "o": "其他",
      "ku_single": "知",
      "t_single": "思",
      "c_single": "沟",
      "a_single": "用",
      "o_single": "其他",
      "w:": "权重:",
      "no_weight": "无权重",
      "overall": "课程总分",
      "average": "平均分数",
      "avg:": "平均：",
      "untitled_assignment": "未命名作业",
      "in_development": "正在开发 🚧",
      "dismiss": "好的",
      "tap_to_view_detail": "点击列表中的一项即可查看详情",
      "google_play_services": "Google Play 服务框架",
      "no_google_play_warning_content": "由于您的设备不支持Google Play服务框架，"
          "您将无法收到通知。",
      "ok": "OK",
      "moodle": "Moodle",
      "cached": "已缓存",
      "project_description": "做最好用的Teach Assist客户端。项目网站：",
      "contact_info": "联系方式",
      "send_feedback": "提交反馈",
      "plz_fill_in_ur_contact_info": "请输入联系方式",
      "plz_fill_in_ur_feedback": "请输入您的反馈",
      "unnamed_course": "未命名课程",
    }
  };

  static updateCurrentLanguage(BuildContext context) {
    currentLanguage = Localizations.localeOf(context).languageCode;
  }

  static String get(String id, [BuildContext context]) {
    if (currentLanguage == null) {
      updateCurrentLanguage(context);
    }
    var string = _strings[currentLanguage][id];
    if (string == null) {
      print("Cannot find id:$id in $currentLanguage");
      string = get("unknown");
    }
    return string;
  }
}
