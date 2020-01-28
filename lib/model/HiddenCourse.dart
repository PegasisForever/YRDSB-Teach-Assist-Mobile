import 'dart:convert';

import 'package:ta/model/Mark.dart';
import 'package:ta/model/User.dart';
import 'package:ta/plugins/dataStore.dart';

class HiddenCourse {
  int id;
  String name;
  String block;
  String room;

  HiddenCourse();

  HiddenCourse.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    block = json["block"];
    room = json["room"];
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "block": block, "room": room};
  }

  bool isMatch(Course course) {
    return id == course.id && name == course.name && block == course.block && room == course.room;
  }

  static _save(List<HiddenCourse> list) {
    var json = [];
    list.forEach((hiddenCourse) => json.add(hiddenCourse.toMap()));
    prefs.setString("hidden-courses-${currentUser.number}", jsonEncode(json));
  }

  static List<HiddenCourse> getAll() {
    var jsonArray = jsonDecode(prefs.getString("hidden-courses-${currentUser.number}") ?? "[]");
    var list = List<HiddenCourse>();
    jsonArray.forEach((json) => list.add(HiddenCourse.fromJSON(json)));
    return list;
  }

  static add(Course course) {
    var hiddenCourse = HiddenCourse();
    hiddenCourse.id = course.id;
    hiddenCourse.name = course.name;
    hiddenCourse.block = course.block;
    hiddenCourse.room = course.room;
    _save(getAll()..add(hiddenCourse));
  }

  static remove(Course course) {
    var listAfterRemove = getAll()..removeWhere((hiddenCourse) => hiddenCourse.isMatch(course));
    _save(listAfterRemove);
  }

  static bool isInList(List<HiddenCourse> hiddenCourseList, Course course) {
    return hiddenCourseList.firstWhere(
          (hidden) => hidden.isMatch(course),
          orElse: () => null,
        ) !=
        null;
  }
}
