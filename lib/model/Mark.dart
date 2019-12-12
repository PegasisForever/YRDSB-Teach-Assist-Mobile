import 'dart:convert';

import 'package:quiver/core.dart';
import 'package:ta/dataStore.dart';
import 'package:ta/prasers/ParsersCollection.dart';
import 'package:ta/res/Strings.dart';

import '../tools.dart';

enum Category {
  KU,
  T,
  C,
  A,
  O,
  F,
}

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

  SmallMark copy() => SmallMark.blank()
    ..available = available
    ..finished = finished
    ..total = total
    ..get = get
    ..weight = weight;

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
  bool added;
  bool expanded;

  Map<Category, SmallMark> get smallMarks {
    return {
      Category.KU: KU,
      Category.T: T,
      Category.C: C,
      Category.A: A,
      Category.O: O,
      Category.F: F,
    };
  }

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

  double getAverage(WeightTable weightTable) {
    var get = 0.0;
    var total = 0.0;
    var weights = weightTable.weights;

    smallMarks.forEach((category, smallMark) {
      if (smallMark.available && smallMark.finished) {
        get += smallMark.get / smallMark.total * weights[category].CW * smallMark.weight;
        total += weights[category].CW * smallMark.weight;
      }
    });

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

    smallMarks.forEach((category, smallMark) {
      if (smallMark.available && smallMark.finished) {
        weight += smallMark.weight;
        count++;
      }
    });

    if (count > 0) {
      return weight / count;
    } else {
      return null;
    }
  }

  bool isAvailable() {
    return (KU.available && KU.finished) ||
        (T.available && T.finished) ||
        (C.available && C.finished) ||
        (A.available && A.finished) ||
        (O.available && O.finished) ||
        (F.available && F.finished);
  }

  bool isNoWeight() {
    return (KU.weight == 0 || !KU.available) &&
        (T.weight == 0 || !T.available) &&
        (C.weight == 0 || !C.available) &&
        (A.weight == 0 || !A.available) &&
        (O.weight == 0 || !O.available) &&
        (F.weight == 0 || !F.available);
  }

  Assignment copy() => Assignment.blank()
    ..KU = KU.copy()
    ..T = T.copy()
    ..C = C.copy()
    ..A = A.copy()
    ..O = O.copy()
    ..F = F.copy()
    ..name = name
    ..feedback = feedback
    ..time = time
    ..edited = edited
    ..expanded = expanded;

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

  Weight copy() => Weight.blank()
    ..W = W
    ..CW = CW
    ..SA = SA;

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

  Map<Category, Weight> get weights {
    return {
      Category.KU: KU,
      Category.T: T,
      Category.C: C,
      Category.A: A,
      Category.O: O,
      Category.F: F,
    };
  }

  WeightTable.blank();

  WeightTable copy() => WeightTable.blank()
    ..KU = KU.copy()
    ..T = T.copy()
    ..C = C.copy()
    ..A = A.copy()
    ..O = O.copy()
    ..F = F.copy();

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

  Course copy() {
    var course = Course.blank()
      ..startTime = startTime
      ..endTime = endTime
      ..name = name
      ..code = code
      ..block = block
      ..room = room
      ..overallMark = overallMark
      ..cached = cached;

    if (overallMark != null) {
      course.assignments = List<Assignment>();
      assignments.forEach((assignment) {
        course.assignments.add(assignment.copy());
      });
      course.weightTable = weightTable.copy();
    }

    return course;
  }

  CourseAnalysis getCourseAnalysis() {
    var analysis = CourseAnalysis.blank();

    var i = 0;
    var gets = <Category, double>{
      Category.KU: 0.0,
      Category.T: 0.0,
      Category.C: 0.0,
      Category.A: 0.0,
      Category.O: 0.0,
      Category.F: 0.0,
    };
    var totals = <Category, double>{
      Category.KU: 0.0,
      Category.T: 0.0,
      Category.C: 0.0,
      Category.A: 0.0,
      Category.O: 0.0,
      Category.F: 0.0,
    };

    assignments.forEach((assi) {
      assi.smallMarks.forEach((category, smallMark) {
        if (smallMark.available && smallMark.finished) {
          gets[category] += smallMark.get / smallMark.total * smallMark.weight;
          totals[category] += smallMark.weight;
        }
      });

      var avg = 0.0;
      var avgn = 0.0;

      var weights = weightTable.weights;
      Category.values.forEach((category) {
        var smallAvg = gets[category] / totals[category];
        if (smallAvg >= 0.0) {
          avg += smallAvg * weights[category].CW;
          avgn += weights[category].CW;
        }

        if (i == assignments.length - 1) {
          if (category == Category.KU) {
            analysis.kuSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          } else if (category == Category.T) {
            analysis.tSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          } else if (category == Category.C) {
            analysis.cSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          } else if (category == Category.A) {
            analysis.aSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          } else if (category == Category.O) {
            analysis.oSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          } else if (category == Category.F) {
            analysis.fSA = smallAvg >= 0 ? smallAvg * 100 : 0;
          }
        }
      });

      if (avgn > 0.0) {
        analysis.overallList.add(avg / avgn * 100);
      } else {
        analysis.overallList.add(null);
      }

      i++;
    });

    return analysis;
  }

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
  int get hashCode => hash4(
      hash4(hash4(hashObjects(assignments), weightTable, startTime, endTime), name, code, block),
      room,
      overallMark,
      cached);
}

class CourseAnalysis {
  var overallList = List<double>();
  double kuSA;
  double tSA;
  double cSA;
  double aSA;
  double oSA;
  double fSA;

  Map<Category, double> get SAs {
    return {
      Category.KU: kuSA,
      Category.T: tSA,
      Category.C: cSA,
      Category.A: aSA,
      Category.O: oSA,
      Category.F: fSA,
    };
  }

  CourseAnalysis.blank();
}

List<Course> getCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-mark") ?? "[]");
  return parseCourseList(json);
}

saveCourseListOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-mark", jsonEncode(json));
}

List<Course> getArchivedCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-archived") ?? "[]");
  return parseCourseList(json);
}

saveArchivedCourseListOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-archived", jsonEncode(json));
}
