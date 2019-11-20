import 'dart:convert';

import 'package:ta/dataStore.dart';
import 'package:ta/prasers/ParsersCollection.dart';
import 'package:ta/res/Strings.dart';

import '../tools.dart';

class SmallMark {
  bool available;
  bool finished;
  double total;
  double get;
  double weight;

  get percent {
    if (!available) {
      return "N/A";
    } else {
      return "${getRoundString((get / total * 100), 2)}%";
    }
  }

  SmallMark.unavailable() {
    this.available = false;
    this.finished = true;
    this.total = 100;
    this.get = 90;
    this.weight = 10;
  }

  SmallMark.blank();
}

class Assignment {
  SmallMark KU;
  SmallMark T;
  SmallMark C;
  SmallMark A;
  SmallMark O;
  SmallMark F;
  String name;
  String feedback;
  DateTime time;
  bool edited;

  Assignment(this.KU, this.T, this.C, this.A, this.O, this.F, this.name, String date) {
    if (date != null) {
      this.time = DateTime.parse(date);
    }
  }

  Assignment.blank();

  get displayName {
    if (name.isNotEmpty) {
      return name;
    } else {
      return Strings.get("untitled_assignment");
    }
  }

  double getAverage(WeightTable weights) {
    var get = 0.0;
    var total = 0.0;

    if (KU.available && KU.finished) {
      get += KU.get / KU.total * weights.KU.CW * KU.weight;
      total += weights.KU.CW * KU.weight;
    }
    if (T.available && T.finished) {
      get += T.get / T.total * weights.T.CW * T.weight;
      total += weights.T.CW * T.weight;
    }
    if (C.available && C.finished) {
      get += C.get / C.total * weights.C.CW * C.weight;
      total += weights.C.CW * C.weight;
    }
    if (A.available && A.finished) {
      get += A.get / A.total * weights.A.CW * A.weight;
      total += weights.A.CW * A.weight;
    }
    if (O.available && O.finished) {
      get += O.get / O.total * weights.O.CW * O.weight;
      total += weights.O.CW * O.weight;
    }

    if (total > 0) {
      var avg = get / total;
      return avg * 100;
    } else {
      return null;
    }
  }

  double getAverageWeight() {
    var weight = 0.0;
    var count = 0.0;
    if (KU.available && KU.finished) {
      weight += KU.weight;
      count++;
    }
    if (T.available && T.finished) {
      weight += T.weight;
      count++;
    }
    if (C.available && C.finished) {
      weight += C.weight;
      count++;
    }
    if (A.available && A.finished) {
      weight += A.weight;
      count++;
    }
    if (O.available && O.finished) {
      weight += O.weight;
      count++;
    }

    if (count > 0) {
      return weight / count;
    } else {
      return null;
    }
  }

  bool isAvailable() {
    return KU.available || T.available || C.available || A.available || O.available;
  }
}

class Weight {
  double W;
  double CW;
  double SA;

  Weight(this.W, this.CW, this.SA);

  Weight.f(this.CW, this.SA);

  Weight.blank();
}

class WeightTable {
  Weight KU;
  Weight T;
  Weight C;
  Weight A;
  Weight O;
  Weight F;

  WeightTable.blank();
}

class Course {
  List<Assignment> assignments;
  WeightTable weightTable;
  DateTime startTime;
  DateTime endTime;
  String name;
  String code;
  String block;
  String room;
  double overallMark;
  bool cached;

  String get displayName {
    if (name != null) {
      return name;
    } else if (code != null) {
      return code;
    } else {
      return Strings.get("unnamed_course");
    }
  }

  Course.blank();
}

List<Course> getCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-mark"));
  return parseCourseList(json);
}

saveCourseListOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-mark", jsonEncode(json));
}
