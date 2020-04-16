import 'dart:convert';

import 'package:quiver/core.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/prasers/ParsersCollection.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

enum Category {
  KU,
  T,
  C,
  A,
  O,
  F,
}

class SmallMark {
  bool enabled = true; //only used in what if mode editor
  bool finished;
  double total;
  double get;
  double weight;

  double get percentage => total > 0.0 ? (get / total) : 0.0;

  SmallMark.blank();

  SmallMark copy() => SmallMark.blank()
    ..enabled = enabled
    ..finished = finished
    ..total = total
    ..get = get
    ..weight = weight;

  @override
  bool operator ==(other) {
    return (other is SmallMark) &&
        finished == other.finished &&
        total == other.total &&
        get == other.get &&
        weight == other.weight;
  }

  @override
  int get hashCode => hash4(finished, weight, total, get);
}

class SmallMarkGroup {
  List<SmallMark> smallMarks = List();

  bool get available => find(smallMarks, (SmallMark it) => it?.enabled == true) != null;

  bool get hasFinished => find(smallMarks, (SmallMark it) => it?.enabled == true && it?.finished == true) != null;

  bool get allFinished => find(smallMarks, (SmallMark it) => !(it?.finished == true)) == null;

  bool get hasWeight => find(smallMarks, (SmallMark it) => it?.enabled == true ? it.weight > 0 : false) != null;

  double get allGet => sum(smallMarks, (SmallMark it) => (it?.finished == true && it?.enabled == true) ? it.get : 0.0);

  double get allTotal =>
      sum(smallMarks, (SmallMark it) => (it?.finished == true && it?.enabled == true) ? it.total : 0.0);

  double get allWeight =>
      sum(smallMarks, (SmallMark it) => (it?.finished == true && it?.enabled == true) ? it.weight : 0.0);

  double get percentage {
    var get = 0.0;
    var total = 0.0;
    smallMarks.forEach((SmallMark smallMark) {
      if (smallMark != null) {
        get += smallMark.percentage * smallMark.weight;
        total += smallMark.weight;
      }
    });
    return total > 0.0 ? (get / total) : 0.0;
  }

  SmallMarkGroup.blank();

  SmallMarkGroup copy() {
    var smallMarkGroup = SmallMarkGroup.blank();
    smallMarks.forEach((smallMark) {
      smallMarkGroup.smallMarks.add(smallMark.copy());
    });
    return smallMarkGroup;
  }

  @override
  bool operator ==(other) {
    return (other is SmallMarkGroup) && hashObjects(smallMarks) == hashObjects(other.smallMarks);
  }

  @override
  int get hashCode => hash2(available, hashObjects(smallMarks));
}

class Assignment {
  String name;
  String feedback;
  DateTime time;
  bool edited;
  bool added;
  bool expanded;
  Map<Category, SmallMarkGroup> smallMarkGroups = {
    Category.KU: null,
    Category.T: null,
    Category.C: null,
    Category.A: null,
    Category.O: null,
    Category.F: null,
  };

  bool get isAvailable {
    for (final category in Category.values) {
      SmallMarkGroup smallMarkGroup = this[category];
      if (smallMarkGroup.available && smallMarkGroup.hasFinished) return true;
    }
    return false;
  }

  bool get isNoWeight {
    for (final category in Category.values) {
      SmallMarkGroup smallMarkGroup = this[category];
      if (smallMarkGroup.hasWeight) return false;
    }
    return true;
  }

  bool get onlyHaveOneSmallMarkGroup {
    var count = 0;
    for (final entry in smallMarkGroups.entries) {
      if (entry.value != null && entry.value.smallMarks.isNotEmpty) {
        count++;
      }
      if (count > 1) {
        return false;
      }
    }
    return count == 1;
  }

  SmallMarkGroup operator [](Category category) => smallMarkGroups[category];

  void operator []=(Category category, SmallMarkGroup smallMarkGroup) => smallMarkGroups[category] = smallMarkGroup;

  Assignment(this.smallMarkGroups, this.name, String date) {
    if (date != null) {
      this.time = DateTime.parse(date);
    }
  }

  Assignment.blank();

  String get displayName {
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

    smallMarkGroups.forEach((category, smallMarkGroup) {
      if (smallMarkGroup.available && smallMarkGroup.hasFinished) {
        get += smallMarkGroup.percentage * smallMarkGroup.allWeight * weights[category].CW;
        total += smallMarkGroup.allWeight * weights[category].CW;
      }
    });

    return total > 0.0 ? (get / total * 100) : null;
  }

  double getAverageWeight() {
    var weight = 0.0;
    var count = 0.0;

    smallMarkGroups.forEach((category, smallMarkGroup) {
      if (smallMarkGroup.available) {
        smallMarkGroup.smallMarks.forEach((smallMark) {
          if (smallMark.finished) {
            weight += smallMark.weight;
            count++;
          }
        });
      }
    });

    if (count > 0) {
      return weight / count;
    } else {
      return null;
    }
  }

  Assignment copy() {
    var assignment = Assignment.blank()
      ..name = name
      ..feedback = feedback
      ..time = time
      ..edited = edited
      ..expanded = expanded;
    Category.values.forEach((category) {
      assignment.smallMarkGroups[category] = smallMarkGroups[category].copy();
    });
    return assignment;
  }

  @override
  bool operator ==(other) {
    if (!((other is Assignment) &&
        name == other.name &&
        feedback == other.feedback &&
        time == other.time &&
        edited == other.edited)) return false;
    for (final category in Category.values) {
      if (this[category] != other[category]) return false;
    }
    return true;
  }

  @override
  int get hashCode => hash2(hash4(name, feedback, time, edited), hashObjects(smallMarkGroups.values));
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
  Map<Category, Weight> weights = {
    Category.KU: null,
    Category.T: null,
    Category.C: null,
    Category.A: null,
    Category.O: null,
    Category.F: null,
  };

  Weight operator [](Category category) => weights[category];

  void operator []=(Category category, Weight weight) => weights[category] = weight;

  WeightTable.blank();

  WeightTable copy() {
    var weightTable = WeightTable.blank();
    for (final category in Category.values) {
      weightTable[category] = this[category].copy();
    }
    return weightTable;
  }

  @override
  bool operator ==(other) {
    if (!(other is WeightTable)) return false;
    for (final category in Category.values) {
      if (this[category] != other[category]) return false;
    }
    return true;
  }

  @override
  int get hashCode => hashObjects(weights.values);
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
  double midTermMark;
  bool cached;
  int id;

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
      ..midTermMark = midTermMark
      ..cached = cached
      ..id = id;

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

    assignments?.forEach((assi) {
      assi.smallMarkGroups.forEach((category, smallMarkGroup) {
        if (smallMarkGroup.hasFinished && smallMarkGroup.available && smallMarkGroup.hasWeight) {
          gets[category] += smallMarkGroup.percentage * smallMarkGroup.allWeight;
          totals[category] += smallMarkGroup.allWeight;
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
          analysis[category] = smallAvg >= 0 ? smallAvg * 100 : 0;
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
        hashNullableObjects(assignments) == hashNullableObjects(other.assignments) &&
        weightTable == other.weightTable &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        name == other.name &&
        code == other.code &&
        block == other.block &&
        room == other.room &&
        overallMark == other.overallMark &&
        cached == other.cached &&
        id == other.id;
  }

  @override
  int get hashCode => hash4(
      hash4(hash4(hashNullableObjects(assignments), weightTable, startTime, endTime), name, code, block),
      room,
      overallMark,
      cached);
}

class CourseAnalysis {
  var overallList = List<double>();
  Map<Category, double> SAs = {
    Category.KU: null,
    Category.T: null,
    Category.C: null,
    Category.A: null,
    Category.O: null,
    Category.F: null,
  };

  double operator [](Category category) => SAs[category];

  void operator []=(Category category, double sa) => SAs[category] = sa;

  CourseAnalysis.blank();
}

List<Course> getCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-mark") ?? "{}");
  return parseCourseList(json);
}

saveCourseListOf(String number, Map<String, dynamic> json, {DateTime time}) {
  prefs.setString("last_update-$number", (time ?? DateTime.now()).toString());
  prefs.setString("$number-mark", jsonEncode(json));
}

List<Course> getArchivedCourseListOf(String number) {
  var json = jsonDecode(prefs.getString("$number-archived") ?? "{}");
  return parseCourseList(json);
}

saveArchivedCourseListOf(String number, Map<String, dynamic> json) {
  prefs.setString("$number-archived", jsonEncode(json));
}
