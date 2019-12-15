import 'package:flutter/material.dart';
import 'package:ta/dataStore.dart';

const Languages = {
  "en": "English",
  "zh": "中文（简体）",
};

class Strings {
  static var currentLanguage;
  static const _strings = {
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
      "assignments": "Assessments",
      "statistics": "Statistics",
      "assignments_unavailable": "Assessments Unavailable",
      "statistics_unavailable": "Statistics Unavailable",
      "course_about_name:": "Course Name: ",
      "course_about_code:": "Course Code: ",
      "course_about_period:": "Period: ",
      "course_about_room:": "Room: ",
      "course_about_starttime:": "Start Time: ",
      "course_about_endtime:": "End Time: ",
      "unknown": "Unknown",
      "ku_long": "Knowledge / Understanding",
      "t_long": "Thinking",
      "c_long": "Communication",
      "a_long": "Application",
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
      "f_single": "F",
      "w:": "W:",
      "no_weight": "No weight",
      "overall": "Overall",
      "average": "Average",
      "avg:": "Avg: ",
      "average:": "Average: ",
      "untitled_assignment": "Untitled Assessment",
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
      "thank_you_for_giving_feedback": "Thank you for giving feedback!",
      "error": "Error: ",
      "search": "Search",
      "clear_all": "Clear All",
      "no_results_found": "No results found",
      "results_from": "Results from \"%s\"",
      "timeline_blank_text": "No updates yet",
      "version_no_longer_supported": "Your APP version is no longer supported, please update.",
      "ur_ta_pwd_has_changed": "Your TA Password Has Changed",
      "u_need_to_update_your_password":
          "You need to update your password in order to view up-to-date marks.",
      "update_password": "Update Password",
      "what_if...": "What if .....",
      "i_got_a_new_mark": "I got a new mark?",
      "teacher_updated_my_mark": "Teacher edited my mark?",
      "what_if_description":
          "In What If Mode, you can edit your assessments without any limitation and see how does it affect your course overall.",
      "enable_what_if_mode": "Enable What If Mode",
      "what_if_mode_activated": "What If Mode Activated",
      "new_assignment": "New Assessment",
      "feedback:": "Feedback: ",
      "remove_assignment": "Remove Assessment \"%s\"?",
      "it_will_be_restored": "It will be restored after disabling what if mode.",
      "assignment_title": "Assessment Title",
      "average_short": "Average",
      "advanced_mode": "Advanced Mode",
      "add": "Add",
      "save": "Save",
      "weight": "Weight",
      "available": "Available",
      "get": "Get",
      "total": "Total",
      "feedback_available": "Feedback available",
      "no_archived_courses": "No archived courses.",
      "manage_accounts_alt": "Manage accounts",
      "dark_mode": "Dark mode",
      "force_light": "Always off",
      "follow_system": "Follow system",
      "force_dark": "Always on",
      "primary_color": "Primary color",
      "default_first_page": "Default first page",
      "show_more_decimal_places": "Show more decimal places",
      "select_a_primary_color": "Select a Primary Color",
      "reset_all_tips": "Reset all tips",
      "tips_reset": "Tips reset",
      "developed_by_students_for_students": "Developed by students for students.",
      "u_got_avg_in_this_assi": "You got average %s%% in this new assessment.",
      "u_got_full_in_this_assi": "You got full mark in this new assessment.",
      "ur_new_avg_of_this_assi": "Your new average of this assessment is %s%%.",
      "ur_avg_of_this_assi_dropped": "Your average of this assessment dropped from %s%% to %s%%.",
      "ur_avg_of_this_assi_increased":
          "Your average of this assessment increased from %s%% to %s%%.",
      "ur_avg_of_this_assi_didnt_change": "Your average of this assessment didn't change.",
      "privacy_policy": "Privacy Policy",
      "support": "Support",
      "update": "Update",
      "language": "Language",
      "assi_edit_tip":"Drag vertically to edit, long press to disable/enable."
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
      "ku_long": "知识",
      "t_long": "思考",
      "c_long": "沟通",
      "a_long": "应用",
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
      "f_single": "期末",
      "w:": "权重:",
      "no_weight": "无权重",
      "overall": "课程总分",
      "average": "平均分数",
      "avg:": "平均：",
      "average:": "平均分数: ",
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
      "thank_you_for_giving_feedback": "感谢反馈！",
      "error": "错误：",
      "search": "搜索",
      "clear_all": "清空",
      "no_results_found": "没有结果",
      "results_from": "来自 “%s” 的结果",
      "timeline_blank_text": "暂无动态",
      "version_no_longer_supported": "您的APP版本已不受支持，请更新。",
      "what_if...": "如果 .....",
      "i_got_a_new_mark": "新的成绩发布了？",
      "teacher_updated_my_mark": "老师给我加分了？",
      "what_if_description": "在编辑模式下，你可以随意更改你的每一项得分，并了解它如何影响你的课程总分。",
      "enable_what_if_mode": "启用编辑模式",
      "what_if_mode_activated": "编辑模式已启用",
      "new_assignment": "添加作业",
      "feedback:": "反馈：",
      "remove_assignment": "确认移除作业 “%s”？",
      "it_will_be_restored": "关闭编辑模式后此作业会重新出现。",
      "assignment_title": "作业标题",
      "average_short": "平均分",
      "advanced_mode": "高级模式",
      "add": "添加",
      "save": "保存",
      "weight": "权重",
      "available": "可用",
      "get": "得分",
      "total": "总分",
      "feedback_available": "老师提供反馈",
      "no_archived_courses": "没有已归档的课程",
      "manage_accounts_alt": "管理账户",
      "dark_mode": "深色模式",
      "force_light": "禁用",
      "follow_system": "跟随系统",
      "force_dark": "始终使用",
      "primary_color": "主色调",
      "default_first_page": "默认首页",
      "show_more_decimal_places": "显示更多小数位数",
      "select_a_primary_color": "请选择一个主色调",
      "reset_all_tips": "重置所有提示",
      "tips_reset": "提示已重置",
      "developed_by_students_for_students": "Developed by students for students.",
      "u_got_avg_in_this_assi": "你在这项作业中获得了平均%s分。",
      "u_got_full_in_this_assi": "你在这项作业中获得了满分。",
      "ur_new_avg_of_this_assi": "这项作业的新平均分是%s分。",
      "ur_avg_of_this_assi_dropped": "这项作业的平均分从%s分下降到了%s分。",
      "ur_avg_of_this_assi_increased": "这项作业的平均分从%s分提高到了%s分。",
      "ur_avg_of_this_assi_didnt_change": "这项作业的平均分没有改变。",
      "privacy_policy": "隐私政策",
      "support": "用户支持",
      "update": "更新",
      "language": "语言",
      "assi_edit_tip":"垂直拖动来调整得分；长按来启用/禁用小项。",
    }
  };

  static updateCurrentLanguage(BuildContext context) {
    currentLanguage = Config.language ?? Localizations.localeOf(context).languageCode;
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
