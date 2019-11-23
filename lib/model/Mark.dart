import 'dart:convert';

import 'package:quiver/core.dart';
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

  @override
  bool operator ==(other) {
    return (other is SmallMark) &&
        available == other.available &&
        finished == other.finished &&
        total == other.total &&
        get == other.get &&
        weight == other.weight;
  }

  @override
  int get hashCode => hash4(available, finished, weight, hash2(total, get));
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

  @override
  bool operator ==(other) {
    return (other is Assignment) &&
        KU == other.KU &&
        T == other.T &&
        C == other.C &&
        A == other.A &&
        O == other.O &&
        F == other.F &&
        name == other.name &&
        feedback == other.feedback &&
        time == other.time &&
        edited == other.edited;
  }

  @override
  int get hashCode => hash4(hash4(hash4(name, feedback, time, edited), KU, T, C), A, O, F);
}

class Weight {
  double W;
  double CW;
  double SA;

  Weight(this.W, this.CW, this.SA);

  Weight.f(this.CW, this.SA);

  Weight.blank();

  @override
  bool operator ==(other) {
    return (other is Weight) && W == other.W && CW == other.CW && SA == other.SA;
  }

  @override
  int get hashCode => hash3(W, CW, SA);
}

class WeightTable {
  Weight KU;
  Weight T;
  Weight C;
  Weight A;
  Weight O;
  Weight F;

  WeightTable.blank();

  @override
  bool operator ==(other) {
    return (other is WeightTable) &&
        KU == other.KU &&
        T == other.T &&
        C == other.C &&
        A == other.A &&
        O == other.O &&
        F == other.F;
  }

  @override
  int get hashCode => hash3(hash4(KU, T, C, A), O, F);
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

  @override
  bool operator ==(other) {
    return (other is Course) &&
        hashObjects(assignments) == hashObjects(other.assignments) &&
        weightTable == other.weightTable &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        name == other.name &&
        code == other.code &&
        block == other.block &&
        room == other.room &&
        overallMark == other.overallMark &&
        cached == cached;
  }

  @override
  int get hashCode =>
      hash4(
          hash4(
              hash4(hashObjects(assignments), weightTable, startTime, endTime), name, code, block),
          room,
          overallMark,
          cached);
}

List<Course> getCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-mark"));
  return parseCourseList(json);
}

saveCourseListOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-mark", jsonEncode(json));
}
